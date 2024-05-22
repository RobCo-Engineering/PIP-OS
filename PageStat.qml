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
        horizontalOffset: -228
    }

    StackLayout {
        anchors.fill: parent
        currentIndex: subMenu.currentIndex

        TabStatus { }
        Item {

        }
        Item {
            Text { color: "white"; text: "Special"}
        }
        Item {
            Text { color: "white"; text: "Collections"}
        }
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
                    text: "HP  %1/%2".arg(dweller.currentHealth).arg(dweller.maxHealth)
                    color: "white"
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: parent.height
                color: "#333"

                Text {
                    id: levelText
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: "LEVEL %1".arg(dweller.level)
                    color: "white"
                }

                ProgressBar {
                    anchors {
                        top: parent.top
                        topMargin: 10
                        right: parent.right
                        rightMargin: 10
                        bottom: parent.bottom
                        bottomMargin: 10
                    }
                    width: parent.width - levelText.implicitWidth - 30
                    progress: dweller.levelProgress
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
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: "AP  %1/%2".arg(dweller.currentAP).arg(dweller.maxAP)
                    color: "white"
                }
            }
        }
    }

    Connections {
        target: inputHandler
        function onStatPressed() {
            subMenu.goToNext()
        }
    }
}
