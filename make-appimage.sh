#!/bin/sh

set -eu

ARCH="$(uname -m)"
export ARCH
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=https://raw.githubusercontent.com/xenia-canary/xenia-canary/refs/heads/canary_experimental/assets/icon/256.png
export DEPLOY_VULKAN=1

# ADD LIBRARIES
quick-sharun ./build/bin/Linux/Release/xenia_canary

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# test the final app
quick-sharun --test ./dist/*.AppImage
