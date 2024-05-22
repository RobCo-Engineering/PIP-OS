import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

Item {
    id: root
    state: InterfaceSettings.skipBoot ? "booted" : "booting"

    property string activePage: "STAT"
    property var pageSources: {
        "STAT": "qrc:/RobCo/PipOS/PageStat.qml",
        "ITEM": "qrc:/RobCo/PipOS/PageItem.qml",
        "DATA": "qrc:/RobCo/PipOS/PageData.qml",
        "MAP": "qrc:/RobCo/PipOS/PageMap.qml",
        "RADIO": "qrc:/RobCo/PipOS/PageRadio.qml",
    }

    layer.enabled: true
    layer.effect: screenOverlay

    // TODO: Move main layout and boot sequence to loaders so that they're not both always running

    BootSequence {
        id: boot
        visible: false
        anchors.fill: parent
        onBootComplete: root.state = "booted"
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
            activeTab: root.activePage
        }

        Loader {
            id: page
            source: pageSources[activePage]
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

        onVisibleChanged: flashIn.start()
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
        function onStatPressed() { root.activePage = "STAT" }
        function onItemPressed() { root.activePage = "ITEM" }
        function onDataPressed() { root.activePage = "DATA" }
        function onMapPressed() { root.activePage = "MAP" }
        function onRadioPressed() { root.activePage = "RADIO" }
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
