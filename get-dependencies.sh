#!/bin/sh

set -eu

ARCH="$(uname -m)"
BINARY="https://github.com/xenia-canary/xenia-canary-releases/releases/latest/download/xenia_canary_linux.tar_.xz"

echo "Installing dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	libx11            \
	sdl2              \
	vulkan-headers    \
	vulkan-icd-loader \
	zlib

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common

echo "---------------------------------------------------------------"
if ! wget --retry-connrefused --tries=30 "$BINARY" -O /tmp/xenia.tar.xz 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi
awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version
tar xvf /tmp/xenia.tar.xz
chmod +x ./build/bin/Linux/Release/xenia_canary
