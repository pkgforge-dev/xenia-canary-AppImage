#!/bin/sh

set -eux

ARCH="$(uname -m)"
URUNTIME="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/uruntime2appimage.sh"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

XENIA_BIN=$(wget -q https://api.github.com/repos/xenia-canary/xenia-canary-releases/releases -O - \
	| sed 's/[()",{} ]/\n/g' | grep -oi "https.*linux.tar.xz$" | head -1)
VERSION=$(echo "$XENIA_BIN" | awk -F'/' '{print $(NF-1); exit}')
echo "$VERSION" > ~/version

export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export OUTNAME=xenia-canary-"$VERSION"-anylinux-"$ARCH".AppImage
export ICON=https://raw.githubusercontent.com/xenia-canary/xenia-canary/refs/heads/canary_experimental/assets/icon/256.png
export DEPLOY_VULKAN=1

# Get binary
wget --retry-connrefused --tries=30 "$XENIA_BIN"
tar xvf "${XENIA_BIN##*/}"
rm -f "${XENIA_BIN##*/}"

# ADD LIBRARIES
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun ./build/bin/Linux/Release/xenia_canary

# MAKE APPIMAGE WITH URUNTIME
wget --retry-connrefused --tries=30 "$URUNTIME" -O ./uruntime2appimage
chmod +x ./uruntime2appimage
./uruntime2appimage

mkdir -p ./dist
mv -v ./*.AppImage* ./dist
mv -v ~/version     ./dist
