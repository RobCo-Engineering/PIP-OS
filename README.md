# PIP-OS V7.1.0.8

##### Copyright 2075 RobCo

### Pre-requisites

```
sudo apt install libegl-dev libopengl-dev libxkbcommon-dev libharfbuzz-dev libmd4c-dev libpulse0
```

## Building from source

The most straightforward way to simply _build_ this code is using a Docker container that already has all of the Qt install inside it.

```sh
docker run -it -v ${PWD}:/src --name qt-build --entrypoint=bash carlonluca/qt-dev:6.7.1

# Inside the container create a build folder and build the app into an AppImage
cd /src
mkdir build; cd build
appimage-builder --recipe ../AppImageBuilder.yml

# Make the AppImage executable
chmod 755 PIP-OS-latest-aarch64.AppImage
```

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

### Item Collections

Counts of items you have listed on the **COLLECTIONS** tab.

```ini
[Collections]
Caps = 1234
Stamps = 3
```

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
