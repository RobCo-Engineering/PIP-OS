import QtQuick 2.15

Item {
    id: root

    signal complete()

    property string activePage: "STAT"
    property var pageSources: {
        "STAT": "qrc:/RobCo/PipOS/PageStat.qml",
        "ITEM": "qrc:/RobCo/PipOS/PageItem.qml",
        "DATA": "qrc:/RobCo/PipOS/PageData.qml",
        "MAP": "qrc:/RobCo/PipOS/PageMap.qml",
        "RADIO": "qrc:/RobCo/PipOS/PageRadio.qml",
    }

    Text {
        color: "white"
        text: "TEST"
    }

    Rectangle {
        id: main
        anchors.fill: root
        color: "black"

        MainNavigation {
            id: mainNav
            anchors {
                top: main.top
                left: main.left
                right: main.right
            }
            activeTab: root.activePage
        }

        Loader {
            id: page
            source: pageSources[activePage]
            anchors {
                top: mainNav.bottom
                left: main.left
                right: main.right
                bottom: main.bottom
            }
        }

        // Reference image loader for alignment in dev
        // Image {
        //     id: ref
        //     visible: false
        //     width: 800
        //     height: 600
        //     anchors.bottom: main.bottom
        //     anchors.horizontalCenter: main.horizontalCenter
        //     source: "/images/ripped_ref_inv.png"
        //     // anchors.horizontalCenterOffset: -8
        //     z: 1
        //     opacity: 0.2
        //     fillMode: Image.PreserveAspectFit
        // }
    }

    Connections {
        target: inputHandler
        function onStatPressed() { root.activePage = "STAT" }
        function onItemPressed() { root.activePage = "ITEM" }
        function onDataPressed() { root.activePage = "DATA" }
        function onMapPressed() { root.activePage = "MAP" }
        function onRadioPressed() { root.activePage = "RADIO" }
    }
}
