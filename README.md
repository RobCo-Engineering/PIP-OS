# PIP-OS V7.1.0.8

##### Copyright 2075 RobCo

## Basic Installation

### Pre-requisites

```
sudo apt install libegl-dev libopengl-dev libxkbcommon-dev libharfbuzz-dev libmd4c-dev libpulse0 libfuse2
```

### Install

```sh
wget https://gitlab.com/robco-industries/pip-os/-/package_files/166831732/download -O PIP-OS-v7.1.0.45-aarch64.AppImage
chmod +x PIP-OS-v7.1.0.45-aarch64.AppImage
./PIP-OS-v7.1.0.45-aarch64.AppImage
```

TODO: Add note about platforms, wayland etc.

## Configuration

The configuration file location depends on your OS, but when you load the app it should log the location where it's loading from eg;

```
...
Loading font ":/assets/fonts/RobotoCondensedLightFallout.ttf"
Loading font ":/assets/fonts/Share-TechMono.ttf"
Interface settings being loaded from "/home/robco/.config/RobCo-Industries/PipOS.ini"
Dweller attributes being loaded from "/home/robco/.config/RobCo-Industries/PipOS.ini"
qml: state changed to boot
qml: state changed to sysinfo
...
```

If the location doesn't exist you can create it and the app will load it at next startup.

There's a large amount of things can be configured in the ini file but here are some examples

### User Interface Settings

Configure various elements of the user interface.

```ini
[Interface]
; Hexidecimal color code for the UI overlay, defaults to the classic green theme but can be changed to anything you like
color=#00ff66

; Optionally skip the boot animation when the app starts
skipBoot=true

; Enable/disable the scanline post-processing effect
scanlines=true

; Scale the interface, 1.0 is full scale, 0.5 is half scale etc.
scale=1.0
```

### Vault Dweller Settings

Configure attributes about your dweller.

```ini
[Dweller]
; Your name, as displayed on the initial STAT page
name=Albert

; Character level
level=123

; Percentage progress to the next level up, 0.0 - 1.0
levelProgress=0.2

; Optionally you can set your birthday and the 'level' will be your age and 'levelProgress' will display the progress until your next birthday.
useBirthdayAsLevel=true
birthday=2015-11-10

; Your SPECIAL stats
specialStrength=1
specialPerception=2
specialAgility=3
specialIntelligence=4
specialLuck=5
specialEndurance=6
specialCharisma=7

; Dweller hitpoints
maxHP=100
currentHP=100

; Dweller AP
maxAP=100
currentAP=100

; Limb health for status page
healthHead=1.0
healthBody=1.0
healthLeftArm=1.0
healthRightArm=1.0
healthLeftLeg=1.0
healthRightLeg=1.0
```

### Inventory

The player inventory is loaded from a JSON URI that can be configured in the main config ini as follows:

```ini
[Inventory]
directory=file:///path/to/file.json
```

The JSON file is in the format that matches the PipBoy Companion app protocol as in https://github.com/NimVek/pipboy, you can use the `DemoMode.json` from that repo as a basic example.

If you want to write your own JSON, a minimal example could be as follows:

```json
{
  "Inventory": {
    "1": [
      { "text": "10mm Pistol", "count": 1, "filterFlag": 2, "equipState": 1 },
      { "text": "Vault 111 Jumpsuit", "count": 1, "filterFlag": 4 }
    ]
  }
}
```

#### Filter Flags

The inventory `filterFlag` field is a 32bit bitwise type field and is used to group items into various categories. The max int for this field would be `4294967295` which implies _all_ items. If an item is for example both a weapon and is also favourited, then you would add the `2` for weapon and `1` for favourite, so the `filterFlag` would be `3`.

|        |                  |
| ------ | ---------------- |
| `1`    | Favourites       |
| `2`    | Weapons          |
| `4`    | Apparel          |
| `8`    | Aid              |
| `128`  | Notes, magazines |
| `512`  | Misc             |
| `1024` | Junk             |
| `2048` | Modifications    |
| `4096` | Ammo             |
| `8192` | Holotapes        |

### Item Collections

Counts of items you have listed on the **COLLECTIONS** tab.

```ini
[Collections]
Caps = 1234
Stamps = 3
```

### Radio

Radio stations should be `.wav` files that are placed into a directory together. The name of the file will have the `.wav` extension stripped and that will be used for the station name. ie. naming a file `Classical Radio.wav` will create a radio station named `Classical Radio`. By default the directory used will be the directory the app is running in, but you can configure the path to look for radio stations as follows:

```ini
[Radio]
directory = "file:///path/to/radio"
```

### Map

The map is implemented using the Stadia Maps tile server for Open Street Map, you'll need an API key to use it but it should be free usage once you've made an account. Create an account over at https://stadiamaps.com and in your account create a new "property" and then generate an API key for it. Once you've got an API key add it to your app settings ini like below.

```ini
[Map]
apiKey="<your API key>"
```

#### Location

The app will try to locate a GPS device by default but you can point it which device to use in the ini as follows, for hints on valid values check the Qt docs here https://doc.qt.io/qt-6/position-plugin-nmea.html:

```ini
[Map]
positionSource=serial:/dev/ttyUSB0
```

#### Using a fake location

If you don't have a valid GPS source, you can also use static data, go to https://nmeagen.org and add a point to the map with "Add point" and then click "Generate NMEA file", save this file somewhere on disk such as `/path/to/location_data.txt` and then set the source in the ini as follows:

```ini
[Map]
positionSource=file:///path/to/location_data.txt
```

## Debugging Startup Issues

## Building from source

The most straightforward way to simply _build_ this code is using a Docker container that already has all of the Qt install inside it.

There are some helper scripts inside `hack/`, you _should_ be able to run `./hack/cross_compile.sh` to build an aarch64 AppImage.

If you're running from a non ARM linux box, you need to first make sure you're running Docker with QEMU enabled as per https://docs.docker.com/build/building/multi-platform/#qemu

## Extracting Vault Boy Sprites

SWF files are extracted from the game using BSA Browser, condition clips exist in `interfaces/components/conditionclips`, for F76 the archive is `SeventySix - Interface.ba2`. From the files in Fallout 76 there are both full colour and monochromatic versions, the latter have the `_mono` postfix. The `.swf` files are opened with JPEXS, ~~each shape is exported as SVG and arranged in a sprite sheet with fixed width frames (120px), sprite sheets are then exported as transparent PNG and rendered using an `AnimatedSprite` in QML. When inspecting the body frames in JPEXS you can find the anchor point which is used for aligning the head elements, each body is a seperate SWF and then all of the heads are in the same SWF, each head needs alignment with the alignment points on the body frames.~~

- open condition_body_x

- open condition_head

  - under shapes, pick the DefineShape for the required head status
  - right click and 'raw edit' and change shapeId to (2) and save
  - right click again and "copy to" to condition_body_x SWF, this should put the head into the slot 2

- under condition_body_x

  - objects are placed every 8th frame
  - on the PlaceObject2 (1) which is positioning the body, we need to center it so click it, click transform at the bottom, expand the 'move' categoy on the right, set to horizontal 65px, vertical 120px, and set to relative, this positions the body for the whole animation
  - do the above again for (2) labelled as (Head_mc) and use the same relative position of 65px and 120px
  - do the above again for the Head_mc of every 8th frame
  - previewing the animation now at the top level the whole animation should render in the middle of the zone with the head in the right position
  - under the 'others' category delete the setBackgroundColor resource, this should make the background transparent
  - right click the frames category and pick export selection and export as GIF

- load the GIF up in CompressOrDie (https://processing.compress-or-die.com/gif-process)
  - set the colors to 16, this should remove the duplicate frames and also squash the colors resulting in a ~95% smaller file
