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

<img width="815" height="640" alt="CaptureZZ" src="https://github.com/user-attachments/assets/7caa4594-8504-40f8-99d6-c3faca2f00c5" />

## Adds TOZED LT70-C modem support to 3GInfo Lite.

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

<img width="616" height="624" alt="CaptureSS" src="https://github.com/user-attachments/assets/3bfa323f-a265-4d29-98ed-66e7406029f5" />

## The project includes modem LED monitoring for the S12 PRO.

LED status can indicate:

LTE signal strength
Internet connectivity
Internet available
Internet unavailable
Boot Network Detection Fix

<img width="1000" height="1000" alt="s12_4" src="https://github.com/user-attachments/assets/e3178bf9-b9d6-402c-8881-442fecef5329" />


Some S12 PRO units may not correctly detect the LTE modem/network immediately after power-on.

The project can restart the OpenWrt network service automatically after boot

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

# Installation
## 1. Flash OpenWrt Firmware

Download the appropriate S12 PRO firmware from the GitHub Releases page.
https://github.com/pasankodi2018/TOZED-S12-Pro-OpenWrt-Firmware-Build/releases/tag/v1.0.0

Example:

kwrt-07.06.2026-ramips-mt7621-tozed_zlt-s12-pro-squashfs-sysupgrade.bin

## Flash the firmware using the appropriate OpenWrt upgrade method for your current firmware.

Important

Do not interrupt power while the router is flashing.

Wait until the router completely reboots.

## 2. Connect to the Router

After OpenWrt starts, connect through SSH.

default in kwrt 

ssh root@10.0.0.1

username - root

password - root

## 3. One-Click Installation

Download the installation script:

```sh
wget -O /tmp/install.sh https://raw.githubusercontent.com/pasankodi2018/S12-Pro-OpenWrt-Firmware-Build/main/install.sh
```

Make it executable:

```sh
chmod +x /tmp/install.sh
```

Run the installer:

```sh
sh /tmp/install.sh
```

The installer automatically installs the required TOZED ZLT S12 PRO modem support and scripts.


## Troubleshooting
### Modem not detected

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
### Modem band driver not found

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

# Credits

OpenWrt / KWRT:

https://openwrt.org/

https://openwrt.ai/

TOZED ZLT S12 PRO:

MT7621 + TOZED LT70-C

This repository contains custom configuration and scripts created for the TOZED ZLT S12 PRO.


---

## 💬 Need Help?

Having an issue with this project?  
Feel free to contact me on WhatsApp for any questions, issues, or support.

<p align="center">
  <a href="https://wa.me/qr/NT32SB4BJB5VA1">
    <img width="864" height="1536" alt="image" src="https://github.com/user-attachments/assets/23cab5de-7d13-41c3-a4d3-058622510d6b" />

  </a>
</p>

<p align="center">
  <b>📱 Scan the QR code or click below to contact me</b>
</p>

<p align="center">
  <a href="https://wa.me/qr/NT32SB4BJB5VA1">
    <img width="483" height="472" alt="shared_qr_code" src="https://github.com/user-attachments/assets/079ffb52-47e8-47ef-b130-fe2b5b68bb9c" />

  </a>
</p>
<img width="1273" height="667" alt="image" src="https://github.com/user-attachments/assets/68647089-3592-4388-886d-64c1c46598bc" />

<img width="1341" height="660" alt="CaptureDS" src="https://github.com/user-attachments/assets/2f2172ca-609f-4100-97ed-8b3c69c21bba" />
<img width="718" height="600" alt="image" src="https://github.com/user-attachments/assets/d42bce4f-fdcf-42a4-8bbf-c6e221179add" />

