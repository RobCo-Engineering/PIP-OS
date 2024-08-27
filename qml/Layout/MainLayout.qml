import QtQuick 2.15
import PipOS

Item {
    id: root

    signal complete()

    property string activePage: "STAT"
    property var pageSources: {
        "STAT":  "qrc:/qml/PipOSApp/qml/Pages/PageStat.qml",
        "ITEM":  "qrc:/qml/PipOSApp/qml/Pages/PageItem.qml",
        "DATA":  "qrc:/qml/PipOSApp/qml/Pages/PageData.qml",
        "MAP":   "qrc:/qml/PipOSApp/qml/Pages/PageMap.qml",
        "RADIO": "qrc:/qml/PipOSApp/qml/Pages/PageRadio.qml",
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
        //     source: "/assets/images/ripped_ref_inv.png"
        //     // anchors.horizontalCenterOffset: -8
        //     z: 1
        //     opacity: 0.2
        //     fillMode: Image.PreserveAspectFit
        // }
    }

    Connections {
        target: App.hid
        function onUserActivity(a) {
            if (a.startsWith("TAB_")) root.activePage = a.replace("TAB_", "")
        }
    }
}
