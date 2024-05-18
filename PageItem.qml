import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls as C

C.Page {
    property alias subMenuIndex: subMenu.currentIndex

    background: Rectangle { color: "black" }

    header: SubMenu {
        id: subMenu
        model: ["NEW", "WEAPONS", "ARMOR", "APPAREL", "FOOD/DRINK", "AID", "MISC", "HOLO", "NOTES", "JUNK", "MODS", "AMMO"]
        horizontalOffset: -80
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
                    text: "± %1".arg(6565)
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
        target: inputHandler
        function onItemPressed() {
            subMenu.goToNext()
        }
    }
}
