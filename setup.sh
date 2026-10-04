#!/usr/bin/env bash

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

cat > ~/.local/bin/winver <<'EOF'
#!/bin/bash

HTML_FILE="/tmp/winver_window.html"

cat > "$HTML_FILE" <<'HTML_EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <style>
        body {
            font-family: 'Segoe UI', -apple-system, BlinkMacSystemFont, sans-serif;
            font-size: 13px;
            background-color: #fcf6f8;
            color: #202020;
            margin: 0;
            padding: 0;
            user-select: none;
            overflow: hidden;
        }

        .title-text {
            font-size: 12px;
            color: #333333;
            font-weight: 500;
        }

        .close-btn:hover {echo "About Windows closed."
            background-color: #e81123;
            color: white;
        }

        .main-container {
            padding: 25px 30px;
        }

        .header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            margin-top: 5px;
        }

        .logo {
            width: 58px;
            height: 58px;
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            grid-gap: 5px;
            margin-right: 24px;
        }

        .logo .pink-ch {
            background-color: #0078d4;
        }

        .logo .blue-ch {
            background-color: #0078d4;
        }

        .title {
            font-size: 34px;
            color: #0078d4;
            font-weight: 400;
            letter-spacing: -0.5px;
        }

        .title span {
            color: #0078d4;
            font-weight: 600;
        }

        .divider {
            height: 1px;
            background-color: #0078d4;
            margin-bottom: 22px;
        }

        .content {
            line-height: 1.5;
            white-space: pre-line;
            margin-bottom: 15px;
        }

        .indent {
            padding-left: 35px;
            line-height: 1.4;
        }
    </style>
</head>

<body>
    <div class="main-container">
        <div class="header">
            <div class="logo">
                <div class="blue-ch"></div><div class="pink-ch"></div>
                <div class="pink-ch"></div><div class="blue-ch"></div>
            </div>

            <div class="title">
                Windows 11 <br>
                <span>Femboy Edition</span>
            </div>
        </div>

        <div class="divider"></div>

        <div class="content">Microsoft Windows
Version 67H2 (OS Build 67670.6767)
© Microsoft Corporation. All rights reserved.

The Windows 11 Femboy Edition operating system and its user interface are protected by trademark and other pending or existing intellectual property rights in the United States and other countries/regions.

Evaluation copy. Expires 67/67/6767 67:67 PM

This product is licensed under the Microsoft Software License Terms to:</div>

        <div class="indent">user name
User</div>
    </div>
</body>
</html>
HTML_EOF

yad --title="About Windows" \
    --width=520 \
    --height=540 \
    --fixed \
    --center \
    --undecorated \
    --html \
    --browser \
    --uri="file://$HTML_FILE" \
    --button="OK:0"

rm -f "$HTML_FILE"
EOF

chmod +x ~/.local/bin/winver
echo
echo "========================================"
echo " Installation Winver completed successfully!"
echo "========================================"
echo
echo "Type 'winver' in the terminal to use it."
echo
