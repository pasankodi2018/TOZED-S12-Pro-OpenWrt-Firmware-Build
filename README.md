# TOZED ZLT S12 PRO – OpenWrt LED Scripts

OpenWrt LED monitoring scripts for the **TOZED ZLT S12 PRO LTE router**.

These scripts automatically control the router's LEDs based on:

- 📶 LTE modem signal strength (RSRP)
- 🌐 Internet connectivity
- 🔵 Blue LEDs when the internet is working
- 🔴 Red LED when the internet is unavailable

## Features

### 📶 LTE Signal LED

The `modem_led` service reads LTE signal strength from the modem using:

```text
AT+ZRSSI?
