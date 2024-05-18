import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root
    state: "booted"

    // TODO: This doesn't run on linuxfb
    layer.enabled: true
    layer.effect: screenOverlay

    BootSequence {
        id: boot
        visible: false
        anchors.fill: parent
        // TODO: Add an onComplete handler that switches root.state to booted
    }

    Rectangle {
        id: main
        visible: false
        anchors.fill: parent
        color: "black"

        MainNavigation {
            id: mainNav
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            activeTab: "STAT"
        }

        Loader {
            id: page
            source: "qrc:/RobCo/PipOS/PageStat.qml"
            anchors {
                top: mainNav.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
        }

        Image {
            id: ref
            visible: false
            width: 800
            height: 600
            anchors.bottom: main.bottom
            anchors.horizontalCenter: main.horizontalCenter
            source: "/images/ripped_ref.png"
            // anchors.horizontalCenterOffset: -8
            z: 1
            opacity: 0.2
            fillMode: Image.PreserveAspectFit
        }
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

            // brightness: 0.05
        }
    }

    Rectangle {
        id: scanlines
        anchors.fill: root
        opacity: 0.1
        color: "black"
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

    Connections {
        target: inputHandler
        function onStatPressed() {
            mainNav.activeTab = "STAT"
            page.source = "qrc:/RobCo/PipOS/PageStat.qml"
        }
        function onItemPressed() {
            mainNav.activeTab = "ITEM"
            page.source = "qrc:/RobCo/PipOS/PageItem.qml"
        }
        function onDataPressed() {
            mainNav.activeTab = "DATA"
            page.source = "qrc:/RobCo/PipOS/PageData.qml"
        }
        function onMapPressed() {
            mainNav.activeTab = "MAP"
            page.source = "qrc:/RobCo/PipOS/PageMap.qml"
        }
        function onRadioPressed() {
            mainNav.activeTab = "RADIO"
            page.source = "qrc:/RobCo/PipOS/PageRadio.qml"
        }
    }

    states: [
        State {
            name: "booting"
            PropertyChanges { target: boot; visible: true }
            PropertyChanges { target: main; visible: false }
        },

        State {
            name: "booted"
            PropertyChanges { target: boot; visible: false }
            PropertyChanges { target: main; visible: true }
        }
    ]
}
