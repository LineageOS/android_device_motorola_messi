# Inherit some common Lineage stuff.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Device
$(call inherit-product, device/motorola/messi/device.mk)

# Device identifiers
BUILD_FINGERPRINT := motorola/messi_verizon/messi:9/PDXS29.84-51-11-5/c69ad:user/release-keys
PRODUCT_BRAND := motorola
PRODUCT_DEVICE := messi
PRODUCT_MANUFACTURER := motorola
PRODUCT_MODEL := moto z3
PRODUCT_NAME := lineage_messi

PRODUCT_BUILD_PROP_OVERRIDES += \
        PRODUCT_NAME=messi \
        PRIVATE_BUILD_DESC="messi-user 9 PDXS29.84-51-11-5 c69ad release-keys"
