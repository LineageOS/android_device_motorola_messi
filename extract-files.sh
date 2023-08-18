#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

function blob_fixup() {
    case "${1}" in
        # Load ZAF configs from vendor
        vendor/lib/libzaf_core.so)
            sed -i "s|/system/etc/zaf|/vendor/etc/zaf|g" "${2}"
            ;;
        # Fix camera recording
        vendor/lib/libmmcamera2_pproc_modules.so)
            sed -i "s/ro.product.manufacturer/ro.product.nopefacturer/" "${2}"
            ;;
        # Load camera metadata shim
        vendor/lib/hw/camera.msm8998.so)
            "${PATCHELF}" --replace-needed libcamera_client.so libcamera_metadata_helper.so "${2}"
            ;;
        # Correct mods gid
        etc/permissions/com.motorola.mod.xml)
            sed -i "s|vendor_mod|oem_5020|g" "${2}"
            ;;
        # Add uhid group for fingerprint service
        vendor/etc/init/android.hardware.biometrics.fingerprint@2.1-service.rc)
            sed -i "s/system input/system uhid input/" "${2}"
            ;;
        # Patch libcutils dep into audio HAL
        vendor/lib/hw/audio.primary.msm8998.so)
            "${PATCHELF}" --replace-needed "libcutils.so" "libprocessgroup.so" "${2}"
            ;;
    esac
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

"./../../${VENDOR}/${DEVICE_COMMON}/extract-files.sh" "$@"
