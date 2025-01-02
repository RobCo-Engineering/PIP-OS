import QtQuick
import QtQuick.Window
import QtMultimedia
import PipOS

Item {
    id: root

    signal complete

    property var pageSources: {
        "STAT": "qrc:/robco-industries.org/PipOS/qml/Pages/PageStat.qml",
        "ITEM": "qrc:/robco-industries.org/PipOS/qml/Pages/PageItem.qml",
        "DATA": "qrc:/robco-industries.org/PipOS/qml/Pages/PageData.qml",
        "MAP": "qrc:/robco-industries.org/PipOS/qml/Pages/PageMap.qml",
        "RADIO": "qrc:/robco-industries.org/PipOS/qml/Pages/PageRadio.qml"
    }

    function changeTab(tab) {
        var tabSource = pageSources[tab]
        if (!tabSource)
            return

        if (page.source != tabSource) {
            mainNav.setActiveTab(tab)
            sfxRotary.play()
        }
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
                if (!mainNav.activeTab)
                    return
                page.setSource(root.pageSources[mainNav.activeTab.text], {
                                   "subMenuCenter": mainNav.activeTab ? mainNav.activeTab.x + mainNav.activeTab.width + 8 : 0
                               })
            }
            tabs: Settings.hideMapTab ? ["STAT", "ITEM", "DATA", "RADIO"] : ["STAT", "ITEM", "DATA", "MAP", "RADIO"]
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
        //     source: "/images/ripped_ref_inv.png"
        //     // anchors.horizontalCenterOffset: -8
        //     z: 1
        //     opacity: 0.2
        //     fillMode: Image.PreserveAspectFit
        // }
    }

    SoundEffect {
        id: sfxRotary
        source: "/sounds/horizontal_tab.wav"
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.TAB_STAT)
        onActivated: root.changeTab("STAT")
        autoRepeat: false
        enabled: page.source != root.pageSources["STAT"]
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.TAB_ITEM)
        onActivated: root.changeTab("ITEM")
        autoRepeat: false
        enabled: page.source != root.pageSources["ITEM"]
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.TAB_DATA)
        onActivated: root.changeTab("DATA")
        autoRepeat: false
        enabled: page.source != root.pageSources["DATA"]
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.TAB_MAP)
        onActivated: root.changeTab("MAP")
        autoRepeat: false
        enabled: page.source != root.pageSources["MAP"]
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.TAB_RADIO)
        onActivated: root.changeTab("RADIO")
        autoRepeat: false
        enabled: page.source != root.pageSources["RADIO"]
    }
}
