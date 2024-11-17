import QtQuick 2.15
import QtQuick.Layouts
import QtMultimedia


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
            data: dataProvider.data
            query: ""
            sortFunction: function(a, b){
                return a.text.localeCompare(b.text);
            } 
        }

        ListView {
            id: list
            anchors.fill: parent
            model: inventory.model
            spacing: 5

            delegate: RowLayout {
                id: item
                required property variant modelData

                width: ListView.view.width

                // visible: (inventoryItem.filterFlag === 1024)

                Rectangle {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    opacity: item.modelData.equipState
                    Layout.preferredWidth: 12
                    Layout.preferredHeight: 12
                }

                Text {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    text: (item.modelData.count === 1) ? item.modelData.text : "%1 (%2)".arg(item.modelData.text).arg(item.modelData.count)
                    font.family: "Roboto Condensed"
                    font.pixelSize: 26
                }

                Text {
                    visible: (item.modelData.isAtom || false)
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    text: "¢"
                    font.family: "Roboto Condensed"
                    font.pixelSize: 26
                }

                Text {
                    visible: (item.modelData.isLegendary || false)
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
        color: "#333"
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

        ListView {
            anchors.fill: parent
            model: list.currentItem ? list.currentItem.modelData.itemCardInfoList: []
            delegate: RowLayout {
                Text{
                    color: "white"
                    text: model.text || ''
                }
                Text{
                    color: "white"
                    text: model.Value || ''
                }
            }
        }
    }

    states: [
        State{
            name: "WEAPONS"
            PropertyChanges {
                target: inventory
                query: "Inventory[**][*filterFlag=2]"
            }
        },
        State{
            name: "APPAREL"
            PropertyChanges {
                target: inventory
                query: "Inventory[**][*filterFlag=4]"
            }
        },
        State{
            name: "AID"
            PropertyChanges {
                target: inventory
                query: "Inventory[**][*filterFlag=8]"
            }
        },
        State{
            name: "MISC"
            PropertyChanges {
                target: inventory
                query: "Inventory[**][*filterFlag=512]"
            }
        },
        State{
            name: "HOLO"
            PropertyChanges {
                target: inventory
                query: "Inventory[**][*filterFlag=8192]"
            }
        },
        State{
            name: "NOTES"
            PropertyChanges {
                target: inventory
                query: "Inventory[**][*filterFlag=128]"
            }
        },
        State{
            name: "JUNK"
            PropertyChanges {
                target: inventory
                query: "Inventory[**][*filterFlag=1024]"
            }
        },
        State{
            name: "AMMO"
            PropertyChanges {
                target: inventory
                query: "Inventory[**][*filterFlag=4096]"
            }
        }
    ]

    SoundEffect {
        id: sfxFocus
        source: "/assets/sounds/item_focus.wav"
    }

    Connections {
        target: hid
        function onUserActivity(a) {
            switch(a) {
            case "SCROLL_UP":
                list.decrementCurrentIndex()
                sfxFocus.play()
                break
            case "SCROLL_DOWN":
                list.incrementCurrentIndex()
                sfxFocus.play()
                break
            case "BUTTON_SELECT":
                const item = list.currentItem.inventoryItem
                console.log(item.HandleID, item.text)
                break
            }
        }
    }
}
