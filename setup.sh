#!/usr/bin/env bash

rm -rf ~/.local/bin/winver

set -e

echo "========================================"
echo " Installer Package"
echo "========================================"

install_package() {
    PACKAGE="$1"

    if command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --needed --noconfirm "$PACKAGE"

    elif command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update
        sudo apt-get install -y "$PACKAGE"

    elif command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y "$PACKAGE"

    elif command -v yum >/dev/null 2>&1; then
        sudo yum install -y "$PACKAGE"

    elif command -v zypper >/dev/null 2>&1; then
        sudo zypper --non-interactive install "$PACKAGE"

    elif command -v apk >/dev/null 2>&1; then
        sudo apk add "$PACKAGE"

    else
        echo "Unsupported Linux distribution."
        exit 1
    fi
}

echo "[1/5] Checking bash..."
command -v bash >/dev/null 2>&1 || install_package bash
echo "OK"

echo "[2/5] Checking coreutils..."
if ! command -v cat >/dev/null 2>&1 || ! command -v rm >/dev/null 2>&1; then
    install_package coreutils
fi
echo "OK"

echo "[3/5] Checking YAD..."
if ! command -v yad >/dev/null 2>&1; then
    install_package yad
fi
echo "OK"

echo "[4/5] Checking xdg-open..."
if ! command -v xdg-open >/dev/null 2>&1; then
    install_package xdg-utils
fi
echo "OK"

echo "[5/5] Checking HTML support..."
if yad --help 2>/dev/null | grep -q -- "--html"; then
    echo "OK"
else
    echo "OK"
fi

echo
echo "========================================"
echo "Installation Package finished successfully."
echo "========================================"
echo
echo "Run YAD HTML with:"
echo "yad --html --browser"
echo

mkdir -p ~/.local/bin

cat << 'EOF' > ~/.local/bin/winver
#!/bin/bash

LOGO_TEXT='<span foreground="#0078d4" font="28">█ █\n█ █</span>'

yad --title="About Windows" \
    --width=480 \
    --height=420 \
    --center \
    --fixed \
    --window-icon="info" \
    --text-align=left \
    --text="
$LOGO_TEXT   <span font='22' foreground='#0078d4'>Windows 11</span>
            <span font='22' weight='bold' foreground='#0078d4'>Femboy Edition</span>

────────────────────────────────────────────────────────────

<b>Microsoft Windows</b>
Version 67H2 (OS Build 67670.6767)
© Microsoft Corporation. All rights reserved.

The Windows 11 Femboy Edition operating system and its user interface are protected by trademark and other pending or existing intellectual property rights in the United States and other countries/regions.

Evaluation copy. Expires 67/67/6767 67:67 PM

This product is licensed under the Microsoft Software License Terms to:
    <b>user name</b>
    <b>User</b>
" \
    --button="OK:0"

EOF

chmod +x ~/.local/bin/winver
echo
echo "========================================"
echo " Installation Winver completed successfully!"
echo "========================================"
echo
echo "Type 'winver' in the terminal to use it."
echo
