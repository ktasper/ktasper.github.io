---
title: "Flashing Tasmota On Smart Plugs Via Tuya-Convert"
date: 2022-09-07T17:19:43+01:00
featuredImage: "images/smart_plug/banner.png"
draft: false
subtitle: "Fiddling with firmware..."
lightgallery: true
---

## Why
I have a Ender-3 3D printer, I want to be able to turn it off when its finished printing without splicing my power cable and using a RaspberryPi's GPIO to cut power. I decided to do it with software
and a SmartPlug. I don't really want some unknown IoT device on my network, so I want to flash it an OpenSource firmware.

Not to mention the OpenSource Firmware (Tasmota) integrates with my OctoPrint Setup.

## My Device
This is the plug I brought: [here](https://www.amazon.co.uk/gp/product/B09QQDVKZD/ref=ppx_yo_dt_b_asin_title_o01_s00?ie=UTF8&th=1) in case the listing is removed here are the details:

```
Name: Smart Plug,Smart Wifi Plug Compatible with Alexa, Google Home, Wifi Plug with Timer Function App Remote Control, No Hub Required, 2.4Ghz ONLY (Energy Monitoring) (1Pack) 
Seller: OHMAXX
EAN: 0638457638929
UPC: 638457638929 
Part No: KU11 
```

{{< image src="images/smart_plug/amazon_listing.png" caption="The amazon listing" height="800"width="800">}}
{{< image src="images/smart_plug/box.jpg" caption="The box" height="500" width="400" >}}
{{< image src="images/smart_plug/plug.jpg" caption="The back of the plug" height="500" width="400" >}}

![Back Of Plug]()

## Checks
When I got the plug, there was a leaflet telling me to install "Gosund" app on my smartphone,
this is good news because that means its almost certainty a Tuya device.

{{< image src="images/smart_plug/leaflet.jpg" caption="The leaflet" height="500" width="400" >}}


## Flashing
This is my documentation on how I managed to flash the firmware on my Plug. This is from box to flash. I did not want the 
plug to pick up an OTA update and blocking my ability to flash it. (Imagine saying that in the early 2000's)

### Tools
- The SmartPlug
- Raspberry Pi 4 (Ethernet)
- Mobile Phone (Android)

### Process

- From my PC I ssh'd into my raspberry pi (Via the Ethernet adapter).


{{< admonition type=failure title="To Docker or Not to Docker" open=true >}}
I tried following the guide for setting it up in Docker containers but I had no luck.
The network SSID never appeared.
{{< /admonition >}}

```sh
cd /tmp/
git clone https://github.com/ct-Open-Source/tuya-convert
cd tuya-convert
./install_prereq.sh
./start_flash.sh
```


- This brought up a warning with the usual "Don't sue me" etc. I skipped this by typing `yes`.


- It also prompted me if I wanted to kill `dnsmasq`, `mosquitto`. I said `yes`



- It then asked me to connect my phone or another device to `vtrust-flash`. I did this via my Samsung A53

- I then plugged in the smart plug, the power light was flashing blue. I assume this is it in pairing mode.

- I then pressed `Enter` and it seemed to find the smart plug.. or so I thought:

```
======================================================
Starting smart config pairing procedure
Waiting for the device to install the intermediate firmware
Put device in EZ config mode (blinking fast)
Sending SSID                  vtrust-flash
Sending wifiPassword
Sending token                 00000000
Sending secret                0101
....
SmartConfig complete.
Resending SmartConfig Packets
.................
SmartConfig complete.
Resending SmartConfig Packets
............
Timed out while waiting for the device to (re)connect
======================================================
Attempting to diagnose the issue...
No ESP82xx based devices connected according to your wifi log.
Here is a list of all the MAC addresses that connected:

<Phone Mac Address>

If you see your IoT device in this list, it is not an ESP82xx based device.
Otherwise, another issue may be preventing it from connecting.
For additional information, check the *.log files inside the scripts folder.
Please include these logs when opening a new issue on our GitHub issue tracker.
======================================================
Do you want to try flashing another device? [y/N] z
======================================================
Cleaning up...
Closing AP
Exiting...

```

- This seems to just be seeing my Phone.

- It seems I had to hold the power button for a few seconds and it started flashing even faster.


- Now the flash was successful

```
======================================================
Starting smart config pairing procedure
Waiting for the device to install the intermediate firmware
Put device in EZ config mode (blinking fast)
Sending SSID                  vtrust-flash
Sending wifiPassword
Sending token                 00000000
Sending secret                0101
................
SmartConfig complete.
Resending SmartConfig Packets
................................................................................................
IoT-device is online with ip 10.42.42.42
Fetching firmware backup
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 1024k  100 1024k    0     0  65712      0  0:00:15  0:00:15 --:--:-- 31304
======================================================
Getting Info from IoT-device
VTRUST-FLASH 1.5
(c) VTRUST GMBH https://www.vtrust.de/35c3/
READ FLASH: http://10.42.42.42/backup
ChipID: 40f806
MAC: <REDACTED>
BootVersion: 7
BootMode: normal
FlashMode: 1M DOUT @ 40MHz
FlashChipId: 144051
FlashChipRealSize: 1024K
Active Userspace: user2 0x81000
======================================================
Ready to flash third party firmware!

For your convenience, the following firmware images are already included in this repository:
  Tasmota v8.1.0.2 (wifiman)
  ESPurna 1.13.5 (base)

You can also provide your own image by placing it in the /files directory
Please ensure the firmware fits the device and includes the bootloader
MAXIMUM SIZE IS 512KB

Available options:
  0) return to stock
  1) flash espurna.bin
  2) flash tasmota.bin
  q) quit; do nothing
Please select 0-2:
```

{{< admonition type=tip title="Save Time Finding The Plug" open=true >}}
If you are like me and have lots of devices on your network, save the MAC so you can find its IP once you get it connected on your home network.
{{< /admonition >}}


- I chose option 2 as I wanted the `tasmota` firmware

#### Post Firmware Flash Config

- I again connect to the `tasmota-xxxx` WiFi via my phone. Navigated to `192.168.4.1`. This presented the Tasmota config screen.

- This is what I filled in for each field:

```
AP1 SSId: This is my Router SSID (To connect it to my network)
AP1
Password: This is my Network Password (To connect it to my network)

AP2 SSId: Left empty
AP2 Password: Left as default (***)

Hostname: Left as default
CORS Domain: Empty
```

- Once I applied I saw a message: `Trying to connect device to network.`

- I then logged into my router, searched for the smart plug MAC and connected via my home network.

{{< admonition type=tip title="Save That IP" open=true >}}
Top Tip: Create a static IP reservation on your router!
{{< /admonition >}}


- I went to `Firmware upgrade` and did an `OTA` Upgrade.


- Next I had to setup my plug. In the Web UI I had to go to `Configuration` -> `Configure Module` -> `Gosund SP1 v23 (55)`



# References
- [Sam on Amazon](https://www.amazon.co.uk/gp/customer-reviews/R1R3W3SS4GUDEY?ref=pf_vv_at_pdctrvw_srp)
- [Tasmota Info on Tuya](https://tasmota.github.io/docs/Tuya-Convert/)
- [Github guide on Tuya-Convert](https://github.com/ct-Open-Source/tuya-convert)
- [Front Page Banner](https://www.dsbd.tech/blogs/press-release-ten-companies-will-test-next-generation-cybersecurity-technologies-from-the-university-of-cambridge-and-arm/)
