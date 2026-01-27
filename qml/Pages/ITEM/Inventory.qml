import QtQuick
import QtQuick.Layouts
import QtMultimedia
import PipOS

import "../../JSONListModel"

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

        // JSONListModel {
        //     id: inventory
        //     data: DataProvider.data
        //     query: ""
        //     sortFunction: function (a, b) {
        //         return a.text.localeCompare(b.text)
        //     }
        // }

        // Component.onCompleted: {
        //     // console.log(JSON.stringify(DataProvider.query("$")))
        //     console.log(JSON.stringify(
        //                     DataProvider.query(
        //                         "$.Inventory[*][?(@.filterFlag==2)]")))
        // }
        DataProvider {
            id: inventory
            query: ""
        }

        ListView {
            id: list
            anchors.fill: parent
            model: inventory.data
            spacing: 5

            delegate: RowLayout {
                id: item
                required property variant modelData

                // Component.onCompleted: {
                //     console.log("modelData", modelData)
                //     console.log("JSONify", JSON.stringify(modelData))
                //     console.log("text", modelData["text"])
                // }
                width: ListView.view.width

                // visible: (inventoryItem.filterFlag === 1024)
                Rectangle {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    opacity: item.modelData.equipState || 0
                    Layout.preferredWidth: 12
                    Layout.preferredHeight: 12
                }

                Text {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    text: (item.modelData.count === 1) ? item.modelData.text : "%1 (%2)".arg(
                                                             item.modelData.text).arg(
                                                             item.modelData.count)
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

                Rectangle {
                    Layout.fillWidth: true
                }
            }
            highlight: Rectangle {
                color: "white"
            }
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

        ItemStats {
            data: inventory.data[list.currentIndex]
            // onDataChanged: {
            //     console.log(inventory.data[list.currentIndex])
            // }
            // list.currentIndex
        }

        ListView {
            anchors.fill: parent
            model: list.currentItem ? list.currentItem.modelData.itemCardInfoList : []
            delegate: RowLayout {

                Text {
                    color: "white"
                    text: model.text || ''
                }
                Text {
                    color: "white"
                    text: model.Value || ''
                }
            }
        }
    }

    states: [
        State {
            name: "WEAPONS"
            PropertyChanges {
                inventory.query: "$.Inventory[*][?(@.filterFlag==2)]"
            }
        },
        State {
            name: "APPAREL"
            PropertyChanges {
                inventory.query: "$.Inventory[*][?(@.filterFlag==4)]"
            }
        },
        State {
            name: "AID"
            PropertyChanges {
                inventory.query: "$.Inventory[*][?(@.filterFlag==8)]"
            }
        },
        State {
            name: "MISC"
            PropertyChanges {
                inventory.query: "$.Inventory[*][?(@.filterFlag==512)]"
            }
        },
        State {
            name: "HOLO"
            PropertyChanges {
                inventory.query: "$.Inventory[*][?(@.filterFlag==8192)]"
            }
        },
        State {
            name: "NOTES"
            PropertyChanges {
                inventory.query: "$.Inventory[*][?(@.filterFlag==128)]"
            }
        },
        State {
            name: "JUNK"
            PropertyChanges {
                inventory.query: "$.Inventory[*][?(@.filterFlag==1024)]"
            }
        },
        State {
            name: "AMMO"
            PropertyChanges {
                inventory.query: "$.Inventory[*][?(@.filterFlag==4096)]"
            }
        }
    ]
    SoundEffect {
        id: sfxFocus
        source: "/sounds/item_focus.wav"
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.SCROLL_UP)
        enabled: root.enabled
        autoRepeat: false
        onActivated: {
            list.decrementCurrentIndex()
            sfxFocus.play()
        }
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.SCROLL_DOWN)
        enabled: root.enabled
        autoRepeat: false
        onActivated: {
            list.incrementCurrentIndex()
            sfxFocus.play()
        }
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.BUTTON_SELECT)
        enabled: root.enabled
        autoRepeat: false
        onActivated: {
            const item = list.currentItem.inventoryItem
            console.log(item.HandleID, item.text)
        }
    }
}
