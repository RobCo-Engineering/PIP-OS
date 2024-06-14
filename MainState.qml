import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root

    state: InterfaceSettings.skipBoot ? "booted" : "booting"

    layer.enabled: true
    layer.effect: screenOverlay

    // Main content is loaded via a loader so boot screen etc. can be unloaded after use
    Loader {
        id: page
        anchors.fill: root
    }

    // Overlay the screen with the color scheme of choice
    Component {
        id: screenOverlay
        MultiEffect {
            source: root
            anchors.fill: root

            colorization: 1
            colorizationColor: InterfaceSettings.color

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
    }

    // Overlay some scanlines over the whole screen
    Rectangle {
        id: scanlines
        anchors.fill: root
        opacity: 0.1
        color: "black"
        visible: InterfaceSettings.scanlines
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

    states: [
        State {
            name: "booting"
            PropertyChanges {
                target: page
                source: "qrc:/RobCo/PipOS/BootSequence.qml"
            }
        },

        State {
            name: "booted"
            PropertyChanges {
                target: page
                source: "qrc:/RobCo/PipOS/MainLayout.qml"
            }
        }
    ]

    // Each loaded screen can have a 'complete' signal to notify it's okay to change state, or something
    Connections {
        target: page.item
        function onComplete() { root.state = "booted" }
    }
}
