#!/bin/bash
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
# This is free software, licensed under the MIT License.

# 1. 添加第三方插件源
echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
# 可选：添加其他插件源（openclash、adguardhome等）
# echo 'src-git openclash https://github.com/vernesong/OpenClash' >>feeds.conf.default

# 2. 注入自定义设备树 mt7981b-fzs-5gcpe-p3.dts 到 target/linux/mediatek/dts/
cat > target/linux/mediatek/dts/mt7981b-fzs-5gcpe-p3.dts <<EOF
// 此处粘贴你完整的设备树dts代码
#include "mt7981.dtsi"

/ {
	model = "FZS 5GCPE P3";
	compatible = "fzs,5gcpe-p3", "mediatek,mt7981";

	// 完整硬件节点：闪存、USB、网口、WiFi、5G模组供电等自行补齐
};
EOF

# 3. 在 mediatek/image/Makefile 末尾追加你的设备定义
cat >> target/linux/mediatek/image/Makefile <<'EOF'
endef
TARGET_DEVICES += cmcc_rax3000m-nand-ubootmod

define Device/fzs_5gcpe-p3
  DEVICE_VENDOR := FZS
  DEVICE_MODEL := 5GCPE P3
  DEVICE_DTS := mt7981b-fzs-5gcpe-p3
  DEVICE_DTS_DIR := ../dts
  UBINIZE_OPTS := -E 5
  BLOCKSIZE := 128k
  PAGESIZE := 2048
  KERNEL_IN_UBI := 1
  DEVICE_PACKAGES := kmod-mt7981-firmware mt7981-wo-firmware kmod-usb3
  IMAGE/sysupgrade.bin := sysupgrade-tar | append-metadata
endef
TARGET_DEVICES += fzs_5gcpe-p3
EOF
