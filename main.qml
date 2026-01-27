pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Effects
import PipOS

Window {
    id: root
    width: 730
    height: 600
    visible: true
    title: qsTr("PIP-OS V7.1.0.8")
    color: "black"

    Item {
        id: sceneRoot
        anchors.fill: parent

        layer.enabled: true
        layer.effect: MultiEffect {
            anchors.fill: parent

            colorization: 1
            colorizationColor: Settings.interfaceColor

            blurEnabled: true
            blur: 0.05
            autoPaddingEnabled: false

            // When the main screen is loaded, we can flicker, for effect
            NumberAnimation on brightness {
                id: flashIn
                from: -1
                to: 0
                easing.type: Easing.OutInElastic
                duration: 1500
            }
        }

        Item {
            id: contentRoot
            anchors.fill: parent

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
                    console.log("bootloader status", status)
                    if (status === Loader.Ready) {
                        appLoader.active = true
                    }
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
        }

        Rectangle {
            id: scanlines
            anchors.fill: parent
            opacity: 0.1
            color: "black"
            visible: Settings.scanLines
            Column {
                spacing: 2
                Repeater {
                    model: 200
                    Rectangle {
                        width: scanlines.width
                        height: 2
                        color: "black"
                    }
                }
            }
        }
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.APP_QUIT)
        context: Qt.ApplicationShortcut
        onActivated: Qt.quit()
    }
}
