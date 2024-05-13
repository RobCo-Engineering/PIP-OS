import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls as C

C.Page {
    id: root
    property alias subMenuIndex: subMenu.currentIndex

    background: Rectangle { color: "black" }

    header: SubMenu {
        id: subMenu
        model: ["STATUS", "EFFECTS", "SPECIAL", "COLLECTIONS"]
        horizontalOffset: -230
    }

    StackLayout {
        anchors.fill: parent
        currentIndex: subMenu.currentIndex

        TabStatus { }
        Item {
            Text { color: "white"; text: "Effects"}
        }
        Item {
            Text { color: "white"; text: "Special"}
        }
        Item {
            Text { color: "white"; text: "Collections"}
        }
    }

    footer: Rectangle {
        height: 38
        color: "#00000000"

        RowLayout {
            spacing: 4
            height: parent.height
            anchors.left: parent.left
            anchors.leftMargin: 34
            anchors.right: parent.right
            anchors.rightMargin: 34

            Rectangle {
                Layout.preferredWidth: 180
                height: parent.height
                color: "#333"

                Text {
                    Layout.alignment: Qt.AlignHCenter
                    leftPadding: 4
                    font.capitalization: Font.AllUppercase
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: "HP  %1/%2".arg(Dweller.currentHealth).arg(Dweller.maxHealth)
                    color: "white"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: parent.height
                color: "#333"

                RowLayout {
                    anchors.fill: parent
                    spacing: 24
                    Text {
                        id: level_text
                        font.pixelSize: 28
                        leftPadding: 10
                        font.capitalization: Font.AllUppercase
                        font.family: "Roboto Condensed Bold"
                        text: "LEVEL %1".arg(Dweller.level)
                        color: "white"
                    }

                    ProgressBar {
                        id: level_progress
                        progress: Dweller.levelProgress
                        Layout.rightMargin: 10
                        height: 18
                        Layout.fillWidth: true
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: 180
                height: parent.height

                color: "#333"

                Text {
                    anchors.fill: parent
                    horizontalAlignment: Text.AlignRight
                    rightPadding: 4

                    font.capitalization: Font.AllUppercase
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: "AP  %1/%2".arg(Dweller.currentAP).arg(Dweller.maxAP)
                    color: "white"
                }
            }
        }
    }
}
