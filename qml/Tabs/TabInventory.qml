import QtQuick 2.15
import QtQuick.Layouts
import PipOS 1.0

Rectangle {
    id: root
    color: "black"

    Rectangle {
        id: listMain
        color: "black"
        anchors {
            top: root.top
            topMargin: 40
            left: root.left
            bottom: root.bottom
            bottomMargin: 60
        }
        width: 400

        ListView {
            id: list
            anchors.fill: parent
            model: App.dweller.inventory
            spacing: 5
            delegate: RowLayout {
                id: item
                property variant inventoryItem: model

                width: ListView.view.width

                Rectangle {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    opacity: (inventoryItem.equipped || false) ? 1 : 0
                    width: 12
                    height: 12
                }

                Text {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    text: (inventoryItem.quantity === 1) ? inventoryItem.name : "%1 (%2)".arg(inventoryItem.name).arg(inventoryItem.quantity)
                    font.family: "Roboto Condensed"
                    font.pixelSize: 26
                }

                Text {
                    visible: (inventoryItem.isAtom || false)
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    text: "¢"
                    font.family: "Roboto Condensed"
                    font.pixelSize: 26
                }

                Text {
                    visible: (inventoryItem.isLegendary || false)
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    text: "¬"
                    font.family: "Roboto Condensed"
                    font.pixelSize: 26
                }

                Rectangle { Layout.fillWidth: true }
            }
            highlight: Rectangle { color: "white" }
            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightFollowsCurrentItem: true
            preferredHighlightBegin: 0
            preferredHighlightEnd: list.bottom
            clip: true
        }
    }

    Rectangle {
        color: "black"
        anchors {
            top: root.top
            topMargin: 46
            left: listMain.right
            leftMargin: 20
            right: root.right
            rightMargin: 20
            bottom: root.bottom
            bottomMargin: 60
        }

        Text {
            color: "white"
            text: list.currentItem.inventoryItem.name
            font.family: "Roboto Condensed"
            font.pixelSize: 26
        }

        ListView {
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }
            height: 500

            Rectangle { color: "#333"; height: 30 }
            Rectangle { color: "#333"; height: 30 }
            Rectangle { color: "#333"; height: 30 }
            Rectangle { color: "#333"; height: 30 }
        }
    }

    Connections {
        target: App.inputHandler
        function onScrollUp() { list.incrementCurrentIndex() }
        function onScrollDown() { list.decrementCurrentIndex() }
        function onScrollPress() {
            // TODO: Is it worth calling a slot?
            // list.currentItem.inventoryItem.toggleEquippedState()
            console.log(list.currentItem.inventoryItem.name)
        }
    }
}
