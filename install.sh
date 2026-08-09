#!/bin/sh

REPO="https://raw.githubusercontent.com/pasankodi2018/Kwrt-modem-led/main"

echo "=========================================="
echo " TOZED ZLT S12 Pro Modem LED Installer"
echo "=========================================="
echo ""

# Check sms_tool
if ! command -v sms_tool >/dev/null 2>&1; then
    echo "ERROR: sms_tool is not installed."
    echo "This firmware does not contain the required modem tool."
    exit 1
fi

# Check modem device
if [ ! -e /dev/ttyUSB0 ]; then
    echo "WARNING: /dev/ttyUSB0 not found."
    echo "The modem may not be ready yet."
fi

echo "[1/3] Downloading modem LED service..."

wget -O /etc/init.d/modem_led "$REPO/modem_led"

if [ $? -ne 0 ]; then
    echo "ERROR: Failed to download modem_led"
    exit 1
fi

echo "[2/3] Setting permissions..."

chmod +x /etc/init.d/modem_led

echo "[3/3] Enabling and starting service..."

/etc/init.d/modem_led enable
/etc/init.d/modem_led restart

echo ""
echo "=========================================="
echo " Installation completed!"
echo "=========================================="
echo ""
echo "Check logs with:"
echo "  logread -e 'Modem LED'"
echo ""
echo "Check service with:"
echo "  /etc/init.d/modem_led status"
echo ""
