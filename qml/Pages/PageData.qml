import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import PipOS

import "../Layout"
import "../Tabs"

Page {
    id: root

    property alias subMenuIndex: subMenu.currentIndex
    property int subMenuCenter
    property variant tabNames: ["MAIN", "SIDE", "DAILY", "EVENT"]

    background: Rectangle {
        color: "black"
    }

    header: SubMenu {
        id: subMenu
        model: root.tabNames
        centerPoint: root.subMenuCenter
    }

    TabQuests {
        id: quests
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
                    function getCurrentDate() {
                        return new Date().toLocaleDateString(
                                    Qt.locale("en_US"), "M.dd.yyyy")
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
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: parent.text = parent.getCurrentDate()
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: 180
                Layout.preferredHeight: parent.height
                color: "#333"

                Text {
                    function getCurrentTime() {
                        return new Date().toLocaleTimeString(
                                    Qt.locale("en_US"), Locale.ShortFormat)
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
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: parent.text = parent.getCurrentTime()
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: parent.height
                color: "#333"
            }
        }
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.TAB_DATA)
        autoRepeat: false
        onActivated: subMenu.goToNext()
    }
}
