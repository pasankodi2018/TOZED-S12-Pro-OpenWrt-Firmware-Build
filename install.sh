#!/bin/sh

REPO="https://raw.githubusercontent.com/pasankodi2018/Kwrt-modem-led/main"

echo "======================================"
echo " TOZED ZLT S12 Pro Modem LED Installer"
echo "======================================"
echo ""

echo "[1/4] Downloading modem LED service..."

wget -O /etc/init.d/modem_led "$REPO/modem_led"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to download modem_led"
    exit 1
fi

echo "[2/4] Setting permissions..."

chmod +x /etc/init.d/modem_led

echo "[3/4] Enabling service at boot..."

/etc/init.d/modem_led enable

echo "[4/4] Starting service..."

/etc/init.d/modem_led restart

echo ""
echo "======================================"
echo " Installation completed!"
echo "======================================"
echo ""
echo "Check service status with:"
echo "  /etc/init.d/modem_led status"
echo ""
