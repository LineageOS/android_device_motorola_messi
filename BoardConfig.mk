#
# Copyright (C) 2017-2024 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# Must set these before including common config
TARGET_BOARD_PLATFORM := msm8998
TARGET_BOOTLOADER_BOARD_NAME := messi
TARGET_SUPPORTS_MOTO_MODS := true

# Inherit from motorola msm8998-common
include device/motorola/msm8998-common/BoardConfigCommon.mk

DEVICE_PATH := device/motorola/messi

# A/B updater
AB_OTA_PARTITIONS += \
    boot \
    system \
    vendor

AB_OTA_UPDATER := true

# Assertations
TARGET_BOARD_INFO_FILE := $(DEVICE_PATH)/board-info.txt
TARGET_OTA_ASSERT_DEVICE := messi

# Camera
MALLOC_SVELTE_FOR_LIBC32 := true

# Display
TARGET_SCREEN_DENSITY := 480

# HIDL
DEVICE_MANIFEST_FILE += $(DEVICE_PATH)/messi_manifest.xml

# Kernel
BOARD_KERNEL_CMDLINE += androidboot.boot_devices=soc/1da4000.ufshc
TARGET_KERNEL_CONFIG := lineageos_messi_defconfig

# Partitions
BOARD_BOOTIMAGE_PARTITION_SIZE := 67108864
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 3338665984
BOARD_VENDORIMAGE_PARTITION_SIZE := 973078528

# Properties
TARGET_VENDOR_PROP += $(DEVICE_PATH)/vendor.prop

# SELinux
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# inherit from the proprietary version
include vendor/motorola/messi/BoardConfigVendor.mk
