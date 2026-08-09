#!/bin/sh

# =========================================================
# TOZED ZLT S12 PRO - LT70-C Support Installer
# =========================================================

REPO="https://raw.githubusercontent.com/pasankodi2018/Kwrt-modem-led/main"

echo "=========================================="
echo " TOZED ZLT S12 PRO Support Installer"
echo "=========================================="

# ---------------------------------------------------------
# Check root
# ---------------------------------------------------------
if [ "$(id -u)" != "0" ]; then
    echo "ERROR: Please run this script as root."
    exit 1
fi

# ---------------------------------------------------------
# Check wget
# ---------------------------------------------------------
if ! command -v wget >/dev/null 2>&1; then
    echo "ERROR: wget is not installed."
    echo "Install it with: opkg update && opkg install wget-ssl"
    exit 1
fi

# ---------------------------------------------------------
# 1. Install modem LED script
# ---------------------------------------------------------

echo ""
echo "[1/4] Installing modem LED service..."

wget -q -O /etc/init.d/modem_led \
    "$REPO/modem_led"

if [ $? -ne 0 ] || [ ! -s /etc/init.d/modem_led ]; then
    echo "ERROR: Failed to download modem_led"
    exit 1
fi

chmod +x /etc/init.d/modem_led

echo "modem_led installed."

# ---------------------------------------------------------
# 2. Install modemband TOZED LT70 definition
# ---------------------------------------------------------

echo ""
echo "[2/4] Installing TOZED LT70-C modemband support..."

mkdir -p /usr/share/modemband

wget -q -O /usr/share/modemband/17824055 \
    "$REPO/modemband/17824055"

if [ $? -ne 0 ] || [ ! -s /usr/share/modemband/17824055 ]; then
    echo "ERROR: Failed to download modemband definition"
    exit 1
fi

chmod 644 /usr/share/modemband/17824055

echo "modemband 17824055 installed."

# ---------------------------------------------------------
# 3. Install 3ginfo-lite TOZED LT70 definition
# ---------------------------------------------------------

echo ""
echo "[3/4] Installing TOZED LT70-C 3GInfo Lite support..."

mkdir -p /usr/share/3ginfo-lite/modem/usb

wget -q -O /usr/share/3ginfo-lite/modem/usb/17824055 \
    "$REPO/3ginfo-lite/modem/usb/17824055"

if [ $? -ne 0 ] || [ ! -s /usr/share/3ginfo-lite/modem/usb/17824055 ]; then
    echo "ERROR: Failed to download 3ginfo-lite definition"
    exit 1
fi

chmod 644 /usr/share/3ginfo-lite/modem/usb/17824055

echo "3ginfo-lite 17824055 installed."

# ---------------------------------------------------------
# 4. Automatic network restart after boot
# ---------------------------------------------------------

echo ""
echo "[4/4] Configuring automatic network restart..."

if [ ! -f /etc/rc.local ]; then
    cat > /etc/rc.local <<'EOF'
#!/bin/sh -e

# Hard reset network stack on boot
sleep 10
/etc/init.d/network restart

exit 0
EOF

    chmod +x /etc/rc.local

else

    if ! grep -qF '/etc/init.d/network restart' /etc/rc.local; then

        sed -i '/^exit 0/i\
# Hard reset network stack on boot\
sleep 10\
/etc/init.d/network restart\
' /etc/rc.local

    fi

    chmod +x /etc/rc.local
fi

echo "Automatic network restart configured."

# ---------------------------------------------------------
# Enable and start modem LED service
# ---------------------------------------------------------

echo ""
echo "Enabling modem LED service..."

/etc/init.d/modem_led enable
/etc/init.d/modem_led restart

# ---------------------------------------------------------
# Finished
# ---------------------------------------------------------

echo ""
echo "=========================================="
echo " Installation completed successfully!"
echo "=========================================="
echo ""
echo "Installed:"
echo "  [OK] modem_led"
echo "  [OK] modemband - TOZED LT70-C"
echo "  [OK] 3ginfo-lite - TOZED LT70-C"
echo "  [OK] Automatic network restart"
echo ""
echo "Network will restart 10 seconds after boot."
echo ""
echo "Recommended: reboot the router now:"
echo ""
echo "    reboot"
echo ""
