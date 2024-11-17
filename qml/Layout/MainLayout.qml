import QtQuick 2.15
import QtQuick.Window
import QtMultimedia

Item {
    id: root

    signal complete()

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
            onActiveTabChanged: {
                if (!mainNav.activeTab) return
                page.setSource(root.pageSources[mainNav.activeTab.text], {
                    subMenuCenter: mainNav.activeTab ? mainNav.activeTab.x + mainNav.activeTab.width + 8 : 0
                })
            }
        }

        Loader {
            id: page
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

    SoundEffect {
        id: sfxRotary
        source: "/assets/sounds/horizontal_tab.wav"
    }

    Connections {
        target: hid
        function onUserActivity(a) {
            if (a.startsWith("TAB_")) {
                var tab = a.replace("TAB_", "")
                var requestedPageSource = root.pageSources[tab]

                if (page.source != requestedPageSource) {
                    mainNav.setActiveTab(tab)
                    sfxRotary.play()
                }
            }
        }
    }
}
