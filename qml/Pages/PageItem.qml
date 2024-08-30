import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls as C
import PipOS 1.0
import "../Layout"
import "../Tabs"

C.Page {
    property alias subMenuIndex: subMenu.currentIndex
    property variant tabNames: ["WEAPONS", "APPAREL", "AID", "MISC", "HOLO", "NOTES", "JUNK", "AMMO"]

    background: Rectangle { color: "black" }

    header: SubMenu {
        id: subMenu
        model: tabNames
        horizontalOffset: -80
    }

    TabInventory {
        id: inventory
        state: tabNames[subMenu.currentIndex]
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
                height: parent.height
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
                height: parent.height
                color: "#333"

                Text {
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: "± %1".arg(App.dweller.collections.find(a => a.name === "Caps").quantity || 0)
                    color: "white"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: parent.height
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

    Connections {
        target: App.hid
        function onUserActivity(a) {
            if (a === "TAB_ITEM") subMenu.goToNext()
        }
    }
}
