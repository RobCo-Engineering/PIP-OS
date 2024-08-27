import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import PipOS 1.0
import "../Layout"

Page {
    property alias subMenuIndex: subMenu.currentIndex

    background: Rectangle { color: "black" }

    header: SubMenu {
        id: subMenu
        model: ["MAIN", "SIDE", "DAILY", "EVENT"]
        horizontalOffset: 70
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
                    function getCurrentDate() {
                        return new Date().toLocaleDateString(Qt.locale("en_US"), "M.dd.yyyy")
                    }

                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: getCurrentDate()
                    color: "white"

                    Timer {
                        interval: 1000; running: true; repeat: true
                        onTriggered: parent.text = parent.getCurrentDate()
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: 180
                height: parent.height
                color: "#333"

                Text {
                    function getCurrentTime() {
                        return new Date().toLocaleTimeString(Qt.locale("en_US"), Locale.ShortFormat)
                    }

                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: getCurrentTime()
                    color: "white"

                    Timer {
                        interval: 1000; running: true; repeat: true
                        onTriggered: parent.text = parent.getCurrentTime()
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: parent.height
                color: "#333"
            }
        }
    }

    Connections {
        target: App.hid
        function onUserActivity(a) {
            if (a === "TAB_DATA") subMenu.goToNext()
        }
    }
}
