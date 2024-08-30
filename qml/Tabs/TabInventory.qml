import QtQuick 2.15
import QtQuick.Layouts
import PipOS 1.0
import "../JSONListModel"

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

        JSONListModel{
            id: inventory
            source: App.settings.inventoryFileLocation
            sortKey: "text"
            query: ""
        }

        ListView {
            id: list
            anchors.fill: parent
            model: inventory.model
            spacing: 5

            delegate: RowLayout {
                id: item
                property variant inventoryItem: model

                width: ListView.view.width

                // visible: (inventoryItem.filterFlag === 1024)

                Rectangle {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    opacity: inventoryItem.equipState
                    width: 12
                    height: 12
                }

                Text {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    text: (inventoryItem.count === 1) ? inventoryItem.text : "%1 (%2)".arg(inventoryItem.text).arg(inventoryItem.count)
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
            text: (list.currentItem && list.currentItem.inventoryItem) ? list.currentItem.inventoryItem.text : ''
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


    states: [
        State{
            name: "WEAPONS"
            PropertyChanges {
                target: inventory
                query: "$.Inventory.[?(@.filterFlag == 2)]"
            }
        },
        State{
            name: "APPAREL"
            PropertyChanges {
                target: inventory
                query: "$.Inventory.[?(@.filterFlag == 4)]"
            }
        },
        State{
            name: "AID"
            PropertyChanges {
                target: inventory
                query: "$.Inventory.[?(@.filterFlag == 8)]"
            }
        },
        State{
            name: "MISC"
            PropertyChanges {
                target: inventory
                query: "$.Inventory.[?(@.filterFlag == 512)]"
            }
        },
        State{
            name: "HOLO"
            PropertyChanges {
                target: inventory
                query: "$.Inventory.[?(@.filterFlag == 8192)]"
            }
        },
        State{
            name: "NOTES"
            PropertyChanges {
                target: inventory
                query: "$.Inventory.[?(@.filterFlag == 128)]"
            }
        },
        State{
            name: "JUNK"
            PropertyChanges {
                target: inventory
                query: "$.Inventory.[?(@.filterFlag == 1024)]"
            }
        },
        State{
            name: "AMMO"
            PropertyChanges {
                target: inventory
                query: "$.Inventory.[?(@.filterFlag == 4096)]"
            }
        }
    ]

    Connections {
        target: App.hid
        function onUserActivity(a) {
            switch(a) {
            case "SCROLL_UP":
                list.decrementCurrentIndex()
                break
            case "SCROLL_DOWN":
                list.incrementCurrentIndex()
                break
            case "BUTTON_SELECT":
                const item = list.currentItem.inventoryItem
                console.log(item.HandleID, item.text)
                break
            }
        }
    }
}
