### Compile Drivers

```
dtc -O dtb -o pipboy-control.dtbo ./hid/pipboy-control.dts
sudo cp pipboy-control.dtbo /boot/firmware/overlays/
```

### Enable Driver

Add the following to `/boot/firmware/config.txt` and reboot. On reboot the INFO LED should be flashing if the driver loaded.

```
dtoverlay=pipboy-control
```
