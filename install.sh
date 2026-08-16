#!/bin/sh

# =========================================================
# TOZED ZLT S12 PRO - Complete LT70-C Setup Installer
# =========================================================

REPO="https://raw.githubusercontent.com/pasankodi2018/Kwrt-modem-led/main"

echo ""
echo "====================================================="
echo " TOZED ZLT S12 PRO - LT70-C Setup Installer"
echo "====================================================="


# ---------------------------------------------------------
# 1. Check root
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Checking Root Access..."
echo "-----------------------------------------------------"

if [ "$(id -u)" != "0" ]; then
    echo "ERROR: Please run this script as root."
    exit 1
fi

echo "Root access: OK"


# ---------------------------------------------------------
# 2. Update package lists
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Updating Package Lists..."
echo "-----------------------------------------------------"

opkg update

if [ $? -ne 0 ]; then
    echo "ERROR: opkg update failed."
    echo "Check your Internet connection and package feeds."
    exit 1
fi


# ---------------------------------------------------------
# 3. Install basic required packages
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Installing Required USB / Modem Packages..."
echo "-----------------------------------------------------"

opkg install kmod-usb-serial
opkg install kmod-usb-serial-option
opkg install kmod-usb-net
opkg install kmod-usb-net-cdc-ncm


# ---------------------------------------------------------
# 4. Install sms_tool
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Installing sms_tool..."
echo "-----------------------------------------------------"

if command -v sms_tool >/dev/null 2>&1; then

    echo "sms_tool already installed."

else

    opkg install sms-tool

    if command -v sms_tool >/dev/null 2>&1; then
        echo "sms_tool installed successfully."
    else
        echo "WARNING: sms_tool was not found in the configured feeds."
        echo "The remaining installation will continue."
    fi

fi


# ---------------------------------------------------------
# 5. Install LuCI compatibility
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Installing LuCI Compatibility Packages..."
echo "-----------------------------------------------------"

opkg install luci-compat 2>/dev/null
opkg install luci-lib-ipkg 2>/dev/null


# ---------------------------------------------------------
# 6. Install 3GInfo Lite
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Installing 3GInfo Lite..."
echo "-----------------------------------------------------"

if opkg list-installed 2>/dev/null | grep -q '^luci-app-3ginfo-lite '; then

    echo "luci-app-3ginfo-lite already installed."

else

    opkg install luci-app-3ginfo-lite

    if [ $? -eq 0 ]; then
        echo "3GInfo Lite installed successfully."
    else
        echo "WARNING: luci-app-3ginfo-lite could not be installed."
        echo "Check your package feeds."
    fi

fi


# ---------------------------------------------------------
# 7. Install ModemBand
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Installing ModemBand..."
echo "-----------------------------------------------------"

opkg install luci-app-atcommands 2>/dev/null

if opkg list-installed 2>/dev/null | grep -q '^luci-app-modemband '; then

    echo "luci-app-modemband already installed."

else

    opkg install luci-app-modemband

    if [ $? -eq 0 ]; then
        echo "ModemBand installed successfully."
    else
        echo "WARNING: luci-app-modemband could not be installed."
        echo "Check your package feeds."
    fi

fi


# ---------------------------------------------------------
# 8. Install TOZED custom ModemBand driver
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Installing TOZED LT70-C ModemBand Driver..."
echo "-----------------------------------------------------"

mkdir -p /usr/share/modemband

wget -q -O /tmp/17824055.modemband \
    "$REPO/modemband/17824055"

if [ $? -ne 0 ] || [ ! -s /tmp/17824055.modemband ]; then

    echo "ERROR: Could not download TOZED ModemBand driver."
    exit 1

fi

cp /tmp/17824055.modemband \
   /usr/share/modemband/17824055

chmod 644 /usr/share/modemband/17824055

rm -f /tmp/17824055.modemband

echo "TOZED LT70-C ModemBand driver installed."


# ---------------------------------------------------------
# 9. Install TOZED 3GInfo Lite driver
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Installing TOZED LT70-C 3GInfo Lite Driver..."
echo "-----------------------------------------------------"

mkdir -p /usr/share/3ginfo-lite/modem/usb

wget -q -O /tmp/17824055.3ginfo \
    "$REPO/3ginfo-lite/modem/usb/17824055"

if [ $? -ne 0 ] || [ ! -s /tmp/17824055.3ginfo ]; then

    echo "ERROR: Could not download TOZED 3GInfo Lite driver."
    exit 1

fi

cp /tmp/17824055.3ginfo \
   /usr/share/3ginfo-lite/modem/usb/17824055

chmod 644 /usr/share/3ginfo-lite/modem/usb/17824055

rm -f /tmp/17824055.3ginfo

echo "TOZED LT70-C 3GInfo Lite driver installed."


# ---------------------------------------------------------
# 10. Install Modem LED service
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Installing Modem LED Service..."
echo "-----------------------------------------------------"

wget -q -O /etc/init.d/modem_led \
    "$REPO/modem_led"

if [ $? -ne 0 ] || [ ! -s /etc/init.d/modem_led ]; then

    echo "ERROR: Could not download modem_led."
    exit 1

fi

chmod +x /etc/init.d/modem_led

/etc/init.d/modem_led enable

echo "Modem LED service installed."


# ---------------------------------------------------------
# 11. Automatic network restart after boot
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Configuring Automatic Network Restart..."
echo "-----------------------------------------------------"

if [ ! -f /etc/rc.local ]; then

cat > /etc/rc.local <<'EOF'
#!/bin/sh -e

# TOZED ZLT S12 PRO
# Restart network after modem initialization

sleep 10
/etc/init.d/network restart

exit 0
EOF

chmod +x /etc/rc.local

else

    if ! grep -qF '/etc/init.d/network restart' /etc/rc.local; then

        sed -i '/^exit 0/i\
# TOZED ZLT S12 PRO - modem/network initialization\
sleep 10\
/etc/init.d/network restart\
' /etc/rc.local

    fi

    chmod +x /etc/rc.local

fi

echo "Automatic network restart configured."


# ---------------------------------------------------------
# 12. Test modem
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Testing LT70-C Modem..."
echo "-----------------------------------------------------"

if command -v sms_tool >/dev/null 2>&1; then

    if [ -e /dev/ttyUSB0 ]; then

        sms_tool -D -d /dev/ttyUSB0 at 'AT+CGMI' 2>/dev/null
        sleep 1

        sms_tool -D -d /dev/ttyUSB0 at 'AT+ZRSSI?' 2>/dev/null

    else

        echo "WARNING: /dev/ttyUSB0 not found yet."

    fi

else

    echo "WARNING: sms_tool is not installed."

fi


# ---------------------------------------------------------
# 13. Start services
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Starting Services..."
echo "-----------------------------------------------------"

/etc/init.d/modem_led restart

/etc/init.d/uhttpd restart 2>/dev/null


# ---------------------------------------------------------
# 14. Final verification
# ---------------------------------------------------------

echo ""
echo "-----------------------------------------------------"
echo " Installation Verification"
echo "-----------------------------------------------------"

echo ""

if command -v sms_tool >/dev/null 2>&1; then
    echo "[OK] sms_tool"
else
    echo "[!!] sms_tool NOT installed"
fi

if opkg list-installed 2>/dev/null | grep -q '^luci-app-3ginfo-lite '; then
    echo "[OK] 3GInfo Lite"
else
    echo "[!!] 3GInfo Lite NOT installed"
fi

if opkg list-installed 2>/dev/null | grep -q '^luci-app-modemband '; then
    echo "[OK] ModemBand"
else
    echo "[!!] ModemBand NOT installed"
fi

if [ -f /usr/share/modemband/17824055 ]; then
    echo "[OK] TOZED ModemBand driver"
else
    echo "[!!] TOZED ModemBand driver missing"
fi

if [ -f /usr/share/3ginfo-lite/modem/usb/17824055 ]; then
    echo "[OK] TOZED 3GInfo Lite driver"
else
    echo "[!!] TOZED 3GInfo Lite driver missing"
fi

if [ -x /etc/init.d/modem_led ]; then
    echo "[OK] Modem LED service"
else
    echo "[!!] Modem LED service missing"
fi

if grep -qF '/etc/init.d/network restart' /etc/rc.local; then
    echo "[OK] Boot network restart"
else
    echo "[!!] Boot network restart missing"
fi


# ---------------------------------------------------------
# Finished
# ---------------------------------------------------------

echo ""
echo "====================================================="
echo " TOZED ZLT S12 PRO SETUP COMPLETED"
echo "====================================================="
echo ""
echo "Installed / configured:"
echo "  - sms_tool"
echo "  - 3GInfo Lite"
echo "  - ModemBand"
echo "  - TOZED LT70-C ModemBand driver"
echo "  - TOZED LT70-C 3GInfo Lite driver"
echo "  - Modem LED service"
echo "  - Automatic boot network restart"
echo ""
echo "A reboot is recommended."
echo ""
echo "Run:"
echo ""
echo "    reboot"
echo ""
