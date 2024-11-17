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
            sortFunction: (a, b) => {
              // First, sort by enabled and active status
              const aStatus = (a.enabled && a.active) ? 2 : (a.enabled ? 1 : 0);
              const bStatus = (b.enabled && b.active) ? 2 : (b.enabled ? 1 : 0);

              if (aStatus !== bStatus) {
                return bStatus - aStatus; // Higher status numbers come first
              }

              // If status is the same, sort alphabetically by text
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

                Item {
                    Layout.preferredWidth: 14
                    Layout.preferredHeight: item.height
                    Text {
                        color: item.ListView.isCurrentItem ? "black" : "white"
                        text:  item.modelData.active ? "": ""
                    }
                }

                // Item text
                Text {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    // item.modelData.enabled
                    text:  item.modelData.text
                    font.strikeout: !item.modelData.enabled
                }

                // Atom store icon from the modified font
                Text {
                    visible: (item.modelData.isAtom || false)
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    text: "¢"
                }

                // Legendary item icon from the modified font
                Text {
                    visible: (item.modelData.isLegendary || false)
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    text: "¬"
                }

                // Fill all remaining space in the RowLayout
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
        color: "#000"
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
            model: list.currentItem ? list.currentItem.modelData.objectives : []
            delegate: Rectangle {
                id: objective
                color: "#333"
                width: parent.width
                height: questText.height

                RowLayout {
                    Item {
                        Layout.preferredWidth: 14
                        Layout.preferredHeight: objective.height+2
                        Text {
                            color:  "white"
                            text:  model.enabled ? "": ""
                        }
                    }

                    Text {
                        // anchors.right: parent.right
                        // Layout.alignment:
                        id: questText
                        Layout.preferredWidth: parent.width
                        color: "white"
                        text: model.text || ''
                        wrapMode: Text.WordWrap
                        font.pixelSize: 26
                        font.strikeout: model.completed
                    }
                }
            }
        }
    }

    states: [
        State{
            name: "MAIN"
            PropertyChanges {
                target: inventory
                // query: "Quests[*enabled=true]"
                query: "Quests"
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
