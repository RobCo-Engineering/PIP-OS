import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as C
import PipOS

import "../../Layout"

C.Page {
    id: root

    property alias subMenuIndex: subMenu.currentIndex
    property int subMenuCenter
    property variant pages: ["STATUS", "EFFECTS", "SPECIAL", "COLLECTIONS"]

    background: Rectangle {
        color: "black"
    }

    header: SubMenu {
        id: subMenu
        model: root.pages
        centerPoint: root.subMenuCenter
    }

    StackLayout {
        id: tab
        anchors.fill: parent

        currentIndex: subMenu.currentIndex

        Status {
            enabled: StackLayout.isCurrentItem
        }
        Effects {
            enabled: StackLayout.isCurrentItem
        }
        Special {
            enabled: StackLayout.isCurrentItem
        }
        Collections {
            enabled: StackLayout.isCurrentItem
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
                    text: "HP  %1/%2".arg(Dweller.currentHealth).arg(
                              Dweller.maxHealth)
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
                    text: "LEVEL %1".arg(Dweller.level)
                    color: "white"
                }

                HealthBar {
                    anchors {
                        top: parent.top
                        topMargin: 10
                        right: parent.right
                        rightMargin: 10
                        bottom: parent.bottom
                        bottomMargin: 10
                    }
                    width: parent.width - levelText.implicitWidth - 30
                    progress: Dweller.levelProgress
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
                    text: "AP  %1/%2".arg(Dweller.currentAP).arg(Dweller.maxAP)
                    color: "white"
                }
            }
        }
    }
}
