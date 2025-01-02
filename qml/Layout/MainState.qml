import QtQuick
import QtQuick.Effects
import PipOS

Item {
    id: root

    state: Settings.skipBoot ? "booted" : "booting"

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
    }

    // Overlay some scanlines over the whole screen
    Rectangle {
        id: scanlines
        anchors.fill: root
        opacity: 0.1
        color: "black"
        // visible: Settings.scanlines
        visible: true
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
                source: "qrc:/robco-industries.org/PipOS/qml/BootSequence.qml"
            }
        },

        State {
            name: "booted"
            PropertyChanges {
                target: page
                source: "qrc:/robco-industries.org/PipOS/qml/Layout/MainLayout.qml"
            }
        },

        State {
            name: "holotape:AtomicCommand"
            PropertyChanges {
                target: page
                source: "qrc:/robco-industries.org/PipOS/qml/Programs/AtomicCommand.qml"
            }
        }
    ]

    // Each loaded screen can have a 'complete' signal to notify it's okay to change state, or something
    Connections {
        target: page.item
        function onComplete() {
            root.state = "booted"
        }
    }

    // When a holotape is loaded we can change the main state to that, for games and such
    Connections {
        target: HolotapeProvider
        function onHolotapeLoaded(tape) {
            root.state = "holotape:" + tape
        }
    }

    Component.onCompleted: {
        DataProvider.loadData(Settings.inventoryFileLocation)
    }
}
