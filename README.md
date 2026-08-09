# TOZED ZLT S12 PRO – OpenWrt Firmware Build

Custom OpenWrt firmware and configuration scripts for the **TOZED ZLT S12 PRO** 4G LTE router.

This project provides a customized OpenWrt firmware build together with scripts and modem configuration files specifically designed for the TOZED ZLT S12 PRO and its **TOZED LT70-C / Unisoc SL8563** LTE modem.

---

## ⚠️ Important

This project is specifically intended for the:

**TOZED ZLT S12 PRO**

Do not flash the firmware on other router models unless you know that the hardware is compatible.

Always keep a backup of your original firmware before upgrading or modifying the router.

Flashing incorrect firmware can permanently damage or brick your router.

---

# Features

### OpenWrt Firmware

Custom KWRT/OpenWrt firmware for:

- TOZED ZLT S12 PRO
- MediaTek MT7621 platform
- RAMIPS / MT7621 target
- SquashFS sysupgrade image

### TOZED LT70-C Modem Support

Includes configuration support for the built-in:

- TOZED LT70-C
- Unisoc / Spreadtrum SL8563
- NCM modem
- `/dev/ttyUSB0`
- `sms_tool`

### Modem Band Lock

Adds TOZED LT70-C support to `modemband`.

Supported LTE bands:

```text
B1
B3
B5
B7
B8
B38
B39
B40
B41

The custom modem driver is:

/usr/share/modemband/17824055

The modem vendor/device ID is:

17824055
3GInfo Lite Support

Adds TOZED LT70-C modem support to 3GInfo Lite.

Configuration location:

/usr/share/3ginfo-lite/modem/usb/17824055

The configuration reads modem information including:

Model
Firmware
Operator
MCC
MNC
IMEI
RSSI
RSRP
RSRQ
SINR
LTE band
PCI
EARFCN
Carrier aggregation information
LTE / LTE-A mode
Modem LED Monitoring

The project includes modem LED monitoring for the S12 PRO.

LED status can indicate:

LTE signal strength
Internet connectivity
Internet available
Internet unavailable
Boot Network Detection Fix

Some S12 PRO units may not correctly detect the LTE modem/network immediately after power-on.

The project can restart the OpenWrt network service automatically after boot:

sleep 10
/etc/init.d/network restart

This gives the modem time to initialize before restarting the network stack.

Firmware
Firmware Target
Target: ramips/mt7621
Device: TOZED ZLT S12 PRO
Filesystem: SquashFS
Image type: Sysupgrade
Firmware Image

The firmware is provided through the GitHub Releases section.

Example:

kwrt-07.06.2026-ramips-mt7621-tozed_zlt-s12-pro-squashfs-sysupgrade.bin

Go to:

Releases → Latest Release → Assets

and download the firmware image.

Installation
1. Flash OpenWrt Firmware

Download the appropriate S12 PRO firmware from the GitHub Releases page.

Example:

kwrt-07.06.2026-ramips-mt7621-tozed_zlt-s12-pro-squashfs-sysupgrade.bin

Flash the firmware using the appropriate OpenWrt upgrade method for your current firmware.

Important

Do not interrupt power while the router is flashing.

Wait until the router completely reboots.

2. Connect to the Router

After OpenWrt starts, connect through SSH.

Example:

ssh root@192.168.1.1

Check the router:

uname -a
3. One-Click Installation

Download the installation script:

wget -O /tmp/install.sh https://raw.githubusercontent.com/pasankodi2018/S12-Pro-OpenWrt-Firmware-Build/main/install.sh

Make it executable:

chmod +x /tmp/install.sh

Run:

sh /tmp/install.sh

The installer installs the required S12 PRO modem support and scripts.

4. Verify the Modem

Check the modem device:

ls -l /dev/ttyUSB*

The LT70-C modem should expose USB serial interfaces.

The primary modem communication port used by this project is:

/dev/ttyUSB0

Check sms_tool:

which sms_tool

Expected:

/usr/bin/sms_tool

Test the modem:

sms_tool -D -d /dev/ttyUSB0 at 'AT+ZRSSI?'

Example response:

+ZRSSI: -76,-7,0,14

OK
5. Verify Modem Band Driver

Check:

ls -l /usr/share/modemband/17824055

The file should exist.

Test the modem band information through the modemband interface.

The custom driver uses:

_DEVICE=/dev/ttyUSB0

Default LTE bands:

1 3 5 7 8 38 39 40 41
6. Verify 3GInfo Lite

Check:

ls -l /usr/share/3ginfo-lite/modem/usb/17824055

The TOZED LT70-C configuration should be present.

This allows 3GInfo Lite to identify the modem and display modem/network information.

7. Boot Network Restart Fix

If the modem is not detected correctly immediately after boot, add the following to:

/etc/rc.local

Before:

exit 0

add:

# Hard reset network stack on boot
sleep 10
/etc/init.d/network restart

The end of /etc/rc.local should look like:

# Hard reset network stack on boot
sleep 10
/etc/init.d/network restart

exit 0

Save the file and reboot:

reboot
Project Structure
S12-Pro-OpenWrt-Firmware-Build/
│
├── README.md
│
├── install.sh
│
├── modem_led
│
├── modemband/
│   └── 17824055
│
└── 3ginfo-lite/
    └── modem/
        └── usb/
            └── 17824055

The firmware itself is distributed separately through:

GitHub Releases
Modem Information
Modem
TOZED LT70-C
Platform
Unisoc / Spreadtrum SL8563
Protocol
NCM
Main AT Command Port
/dev/ttyUSB0
Example Signal Command
sms_tool -D -d /dev/ttyUSB0 at 'AT+ZRSSI?'
Supported LTE Bands

The custom modemband driver supports:

LTE Band	Type
B1	FDD
B3	FDD
B5	FDD
B7	FDD
B8	FDD
B38	TDD
B39	TDD
B40	TDD
B41	TDD

The default supported-band list is:

1 3 5 7 8 38 39 40 41
Troubleshooting
Modem not detected

Check:

ls -l /dev/ttyUSB*

Then:

which sms_tool

Test:

sms_tool -D -d /dev/ttyUSB0 at 'AT+ZRSSI?'

If the modem appears only after restarting the network, use the boot network restart fix described above.

/usr/bin/internet-detector not found

Check:

ls -l /usr/bin/internet-detector

If it does not exist, reinstall the project using:

sh /tmp/install.sh
Modem band driver not found

Check:

ls -l /usr/share/modemband/17824055

If missing, run the installer again.

3GInfo Lite does not detect the modem

Check:

ls -l /usr/share/3ginfo-lite/modem/usb/17824055

Make sure the custom TOZED LT70-C modem configuration exists.

Warning About Band Locking

Band locking changes the LTE bands available to the modem.

Incorrect band selection can cause:

No network connection
Loss of LTE service
Difficulty reconnecting to the network

If you lose connectivity after band locking, restore a wider set of supported bands.

Credits

OpenWrt / KWRT:

https://openwrt.org/

TOZED ZLT S12 PRO:

MT7621 + TOZED LT70-C

This repository contains custom configuration and scripts created for the TOZED ZLT S12 PRO.
