#!/bin/sh

set -eu

ARCH="$(uname -m)"
BINARY="https://github.com/xenia-canary/xenia-canary-releases/releases/latest/download/xenia_canary_linux.tar.xz"
EXTRA_PACKAGES="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh"

echo "Installing dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	base-devel        \
	cmake             \
	curl              \
	git               \
	libx11            \
	libxrandr         \
	libxss            \
	pulseaudio        \
	pulseaudio-alsa   \
	sdl2              \
	vulkan-headers    \
	vulkan-icd-loader \
	wget              \
	xorg-server-xvfb  \
	zlib              \
	zsync

if ! wget --retry-connrefused --tries=30 "$BINARY" -O /tmp/xenia.tar.xz 2>/tmp/download.log; then
	cat /tmp/download.log
	exit 1
fi
awk -F'/' '/Location:/{print $(NF-1); exit}' /tmp/download.log > ~/version

tar xvf /tmp/xenia.tar.xz
chmod +x ./build/bin/Linux/Release/xenia_canary

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$EXTRA_PACKAGES" -O ./get-debloated-pkgs.sh
chmod +x ./get-debloated-pkgs.sh
./get-debloated-pkgs.sh --add-mesa gtk3-mini libxml2-mini opus-mini gdk-pixbuf2-mini librsvg-mini

