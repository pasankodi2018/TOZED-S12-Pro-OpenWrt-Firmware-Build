#!/bin/sh

REPO="https://raw.githubusercontent.com/pasankodi2018/Kwrt-modem-led/main"

echo "======================================"
echo " TOZED S12 Pro ModemBand Installer"
echo "======================================"

if [ "$(id -u)" != "0" ]; then
    echo "ERROR: Please run this script as root."
    exit 1
fi

echo "[1/4] Checking sms_tool..."

if [ ! -x /usr/bin/sms_tool ]; then
    echo "ERROR: sms_tool not found."
    echo "This installer requires the TOZED S12 Pro firmware with sms_tool."
    exit 1
fi

echo "[2/4] Creating modemband directory..."

mkdir -p /usr/share/modemband

echo "[3/4] Downloading TOZED LT70 driver..."

if ! wget -O /usr/share/modemband/17824055 \
    "$REPO/modemband/17824055"; then

    echo "ERROR: Failed to download 17824055"
    exit 1
fi

chmod 755 /usr/share/modemband/17824055

echo "[4/4] Checking installation..."

if [ -x /usr/share/modemband/17824055 ]; then
    echo ""
    echo "======================================"
    echo " Installation successful!"
    echo "======================================"
    echo ""
    echo "Installed:"
    echo "/usr/share/modemband/17824055"
else
    echo "ERROR: Installation failed."
    exit 1
fi
