pragma ComponentBehavior

import QtQuick
import PipOS

Window {
    id: root
    width: 730
    height: 600
    visible: true
    title: qsTr("PIP-OS V7.1.0.8")
    color: "black"

    // property alias appContext: app
    Loader {
        id: bootLoader

        visible: true
        asynchronous: false

        width: 730
        height: 600
        transform: [
            Scale {
                id: bootLoaderScale
                xScale: yScale
                yScale: Math.min(
                            root.width / bootLoader.width,
                            root.height / bootLoader.height) * Settings.scale
            },
            Translate {
                x: Settings.xOffset
                y: Settings.yOffset
            }
        ]

        sourceComponent: BootSequence {
            appIsReady: appLoader.status === Loader.Ready
            bootIsComplete: Settings.skipBoot
            onSystemReadyChanged: {
                console.log("bootloader ready", systemReady)
                if (systemReady) {
                    appLoader.visible = true
                    bootLoader.visible = false
                    bootLoader.active = false
                }
            }

            // onComplete: {
            //     property bool bootIsComplete: false
            //     property bool appIsReady: false
            //     property bool systemReady: bootIsComplete && appIsReady
            // }
        }

        onStatusChanged: {
            console.log("booatloader status", status)
            if (status === Loader.Ready)
            appLoader.active = true
        }
    }

    Loader {
        id: appLoader

        visible: false
        active: false
        asynchronous: true

        width: 730
        height: 600
        transform: [
            Scale {
                id: appLoaderScale
                xScale: yScale
                yScale: Math.min(
                            root.width / appLoader.width,
                            root.height / appLoader.height) * Settings.scale
            },
            Translate {
                x: Settings.xOffset
                y: Settings.yOffset
            }
        ]

        sourceComponent: MainState {}
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.APP_QUIT)
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }
}
