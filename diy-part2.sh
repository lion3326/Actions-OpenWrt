#!/bin/bash
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)

# 1. 修改默认后台地址（可选）
sed -i 's/192.168.1.1/192.168.2.1/g' package/base-files/files/bin/config_generate

# 2. 固定选中MT7981设备 fzs_5gcpe-p3
sed -i '/CONFIG_TARGET_mediatek_mt7981_DEVICE_/d' .config
echo 'CONFIG_TARGET_mediatek_mt7981_DEVICE_fzs_5gcpe-p3=y' >> .config

# 3. 强制开启5G/USB/WiFi依赖包（防止.config丢失配置）
echo "CONFIG_PACKAGE_kmod-mt7981-firmware=y" >> .config
echo "CONFIG_PACKAGE_mt7981-wo-firmware=y" >> .config
echo "CONFIG_PACKAGE_kmod-usb3=y" >> .config
echo "CONFIG_PACKAGE_mbim-utils=y" >> .config
echo "CONFIG_PACKAGE_uqmi=y" >> .config
echo "CONFIG_PACKAGE_modemmanager=y" >> .config

# 4. 生成完整defconfig配置
make defconfig
