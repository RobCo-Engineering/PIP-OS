import QtQuick
import PipOS

Rectangle {
    id: root
    color: "black"

    signal complete

    state: ""

    // Only start boot once component has loaded
    Component.onCompleted: root.state = "boot"

    // Scrolling random character phase
    Text {
        id: bootText

        anchors {
            top: root.bottom
            topMargin: 0
            left: root.left
            leftMargin: 64
        }

        color: "white"
        text: BootScreen.bootingText
        font.pixelSize: 16
        font.family: "Share-TechMono Regular"
    }

    // Information about system specs phase
    Text {
        id: systemText

        property int currentIndex: 0

        anchors {
            top: root.top
            topMargin: 30
            left: root.left
            leftMargin: 75
        }

        color: "white"
        text: ""
        font.pixelSize: 22
        font.family: "Share-TechMono Regular"

        Timer {
            id: systemTextTimer
            interval: 20
            running: false
            repeat: true
            onTriggered: {
                if (systemText.currentIndex < BootScreen.systemText.length) {
                    systemText.text += BootScreen.systemText.charAt(
                                systemText.currentIndex)
                    systemText.currentIndex++
                } else {
                    systemTextTimer.running = false
                    root.state = "initiating"
                }
            }
        }
    }

    AnimatedImage {
        id: bootVaultBoy

        anchors {
            horizontalCenter: root.horizontalCenter
            verticalCenter: root.verticalCenter
            verticalCenterOffset: -20
        }

        source: "/images/initiating.gif"
        visible: false
        paused: true

        onFrameChanged: if (currentFrame === frameCount - 1) {
                            playing = false
                            root.state = "booted"
                            complete()
                        }
    }

    states: [
        State {
            name: "boot"
            AnchorChanges {
                target: bootText
                anchors.bottom: root.top
                anchors.top: undefined
            }
        },
        State {
            name: "sysinfo"
            PropertyChanges {
                target: systemTextTimer
                running: true
            }
        },
        State {
            name: "initiating"
            AnchorChanges {
                target: systemText
                anchors.bottom: root.top
                anchors.top: undefined
            }
        },
        State {
            name: "initiating_vaultboy"
            PropertyChanges {
                target: systemText
                visible: false
            }
            PropertyChanges {
                target: bootVaultBoy
                visible: true
                paused: false
            }
        },
        State {
            name: "booted"
        }
    ]

    onStateChanged: console.debug("state changed to", root.state)

    transitions: [
        Transition {
            to: "boot"
            AnchorAnimation {
                targets: [bootText]
                duration: 3500
                easing.type: Easing.InQuad
            }
            onRunningChanged: if (root.state === "boot" && !running)
                                  root.state = "sysinfo"
        },
        Transition {
            to: "initiating"
            AnchorAnimation {
                targets: [systemText]
                duration: 600
                easing.type: Easing.Linear
            }
            onRunningChanged: if (root.state === "initiating" && !running)
                                  root.state = "initiating_vaultboy"
        }
    ]
}
