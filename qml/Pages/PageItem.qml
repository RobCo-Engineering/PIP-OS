import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as C
import PipOS

import "../Layout"
import "../Tabs"

C.Page {
    id: root

    property alias subMenuIndex: subMenu.currentIndex
    property int subMenuCenter
    property variant tabNames: ["WEAPONS", "APPAREL", "AID", "MISC", "HOLO", "NOTES", "JUNK", "AMMO"]

    background: Rectangle {
        color: "black"
    }

    header: SubMenu {
        id: subMenu
        model: root.tabNames
        centerPoint: root.subMenuCenter
    }

    TabInventory {
        id: inventory
        state: root.tabNames[subMenu.currentIndex]
        anchors.fill: parent
    }

    footer: Rectangle {
        height: 40
        color: "#00000000"

        RowLayout {
            spacing: 4
            height: parent.height
            anchors.left: parent.left
            anchors.right: parent.right

            Rectangle {
                Layout.preferredWidth: 180
                Layout.preferredHeight: parent.height
                color: "#333"

                Text {
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: "217/300"
                    color: "white"
                }
            }

            Rectangle {
                Layout.preferredWidth: 180
                Layout.preferredHeight: parent.height
                color: "#333"

                Text {
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: "± %1".arg(Dweller.collections.find(
                                         a => a.name === "Caps").quantity || 0)
                    color: "white"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height
                color: "#333"

                Text {
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: "-"
                    color: "white"
                }
            }
        }
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.TAB_ITEM)
        autoRepeat: false
        onActivated: subMenu.goToNext()
    }
}
