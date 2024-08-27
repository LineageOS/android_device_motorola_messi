#!/bin/bash
#
# SPDX-FileCopyrightText: 2016 The CyanogenMod Project
# SPDX-FileCopyrightText: 2017-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        # Fix camera recording
        vendor/lib/libmmcamera2_pproc_modules.so)
            [ "$2" = "" ] && return 0
            sed -i "s/ro.product.manufacturer/ro.product.nopefacturer/" "${2}"
            ;;
        # Load ZAF configs from vendor
        vendor/lib/libzaf_core.so)
            [ "$2" = "" ] && return 0
            sed -i "s|/system/etc/zaf|/vendor/etc/zaf|g" "${2}"
            ;;
        # Load camera metadata shim
        vendor/lib/hw/camera.msm8998.so)
            [ "$2" = "" ] && return 0
            grep -q "libcamera_metadata_helper.so" "${2}" || "${PATCHELF}" --add-needed "libcamera_metadata_helper.so" "${2}"
            ;;
        # Correct mods gid
        system/etc/permissions/com.motorola.mod.xml)
            [ "$2" = "" ] && return 0
            sed -i "s|vendor_mod|oem_5020|g" "${2}"
            ;;
        # Add uhid group for fingerprint service
        vendor/etc/init/android.hardware.biometrics.fingerprint@2.1-service.rc)
            [ "$2" = "" ] && return 0
            sed -i "s/system input/system uhid input/" "${2}"
            ;;
        # Patch libcutils dep into audio HAL
        vendor/lib/hw/audio.primary.msm8998.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libcutils.so" "libprocessgroup.so" "${2}"
            ;;
        # Fix missing symbol _ZN7android8hardware7details17gBnConstructorMapE
        system/lib64/motorola.hardware.vibrator@1.0.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libhidlbase.so" "libhidlbase-v32.so" "${2}"
            ;;
        vendor/lib64/com.fingerprints.extension@1.0.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libhidlbase.so" "libhidlbase-v32.so" "${2}"
            ;;
        # New naming for libstdc++
        vendor/lib*/libdualcameraddm.so|vendor/lib*/libvideobokeh.so|vendor/lib/libmmcamera_hdr_gb_lib.so)
            [ "$2" = "" ] && return 0
            "${PATCHELF}" --replace-needed "libstdc++.so" "libstdc++_vendor.so" "${2}"
            ;;
        *)
            return 1
            ;;
    esac

    return 0
}

function blob_fixup_dry() {
    blob_fixup "$1" ""
}

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export DEVICE=messi
export DEVICE_COMMON=msm8998-common
export VENDOR=motorola
export VENDOR_COMMON=${VENDOR}

"./../../${VENDOR_COMMON}/${DEVICE_COMMON}/extract-files.sh" "$@"
