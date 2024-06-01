import QtQuick 2.15
import QtQuick.Layouts
import QtQuick.Controls as C

C.Page {
    id: root
    property alias subMenuIndex: subMenu.currentIndex

    property variant tabNames: ["STATUS", "EFFECTS", "SPECIAL", "COLLECTIONS"]

    background: Rectangle { color: "black" }

    header: SubMenu {
        id: subMenu
        model: tabNames
        horizontalOffset: -228
    }

    state: tabNames[subMenu.currentIndex]

    Loader {
        id: tab
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

    states: [
        State {
            name: "STATUS"
            PropertyChanges {
                target: tab
                source: "qrc:/RobCo/PipOS/TabStatus.qml"
            }
        },
        State {
            name: "EFFECTS"
            PropertyChanges {
                target: tab
                source: "qrc:/RobCo/PipOS/TabEffects.qml"
            }
        },
        State {
            name: "SPECIAL"
            PropertyChanges {
                target: tab
                source: "qrc:/RobCo/PipOS/TabSpecial.qml"
            }
        },
        State {
            name: "COLLECTIONS"
            PropertyChanges {
                target: tab
                source: "qrc:/RobCo/PipOS/TabCollections.qml"
            }
        }
    ]

    Connections {
        target: inputHandler
        function onStatPressed() {
            subMenu.goToNext()
        }
    }
}
