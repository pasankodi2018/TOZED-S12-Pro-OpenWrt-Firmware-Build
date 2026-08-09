#!/bin/sh

REPO="https://raw.githubusercontent.com/pasankodi2018/Kwrt-modem-led/main"

echo "Installing Kwrt Modem LED scripts..."

mkdir -p /etc/init.d

wget -O /etc/init.d/modem_led "$REPO/modem_led"
wget -O /etc/init.d/internet-detector "$REPO/internet-detector"

chmod +x /etc/init.d/modem_led
chmod +x /etc/init.d/internet-detector

/etc/init.d/modem_led enable
/etc/init.d/internet-detector enable

/etc/init.d/modem_led restart
/etc/init.d/internet-detector restart

echo ""
echo "Installation completed!"
echo "Modem LED service: OK"
echo "Internet detector: OK"
