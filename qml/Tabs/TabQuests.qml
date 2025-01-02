import QtQuick
import QtQuick.Layouts
import QtMultimedia
import PipOS

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

        JSONListModel {
            id: inventory
            data: DataProvider.data
            query: ""
            sortFunction: (a, b) => {
                              // First, sort by enabled and active status
                              const aStatus = (a.enabled
                                               && a.active) ? 2 : (a.enabled ? 1 : 0)
                              const bStatus = (b.enabled
                                               && b.active) ? 2 : (b.enabled ? 1 : 0)

                              if (aStatus !== bStatus) {
                                  return bStatus - aStatus // Higher status numbers come first
                              }

                              // If status is the same, sort alphabetically by text
                              return a.text.localeCompare(b.text)
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
                        text: item.modelData.active ? "" : ""
                    }
                }

                // Item text
                Text {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    // item.modelData.enabled
                    text: item.modelData.text
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

    AnimatedImage {
        id: questImage
        anchors {
            top: root.top
            topMargin: 16
            left: listMain.right
            leftMargin: 20
            right: root.right
            rightMargin: 20
        }
        source: "/images/quest_default.gif"
        fillMode: Image.PreserveAspectFit
        Layout.preferredHeight: 200
    }

    ColumnLayout {
        anchors {
            left: questImage.left
            right: questImage.right
            top: questImage.bottom
            topMargin: 20
            // bottom: root.bottom
            // bottomMargin: 60
        }

        spacing: 4

        Repeater {
            model: list.currentItem ? list.currentItem.modelData.objectives : []
            delegate: Rectangle {
                id: objective
                color: "#333"
                Layout.fillWidth: true
                Layout.preferredHeight: questText.paintedHeight

                // Item {
                //     Layout.preferredWidth: 14
                //     Layout.preferredHeight: objective.height+2
                //     Text {
                //         color:  "white"
                //         text:  model.enabled ? "": ""
                //     }
                // }
                Text {
                    id: questText
                    anchors.top: parent.top
                    anchors.topMargin: -4
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.rightMargin: 20

                    color: "white"
                    text: model.text || ''
                    wrapMode: Text.WordWrap
                    font.pixelSize: 26
                    font.strikeout: model.completed
                }
            }
        }
    }

    states: [
        State {
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
        source: "/sounds/item_focus.wav"
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.SCROLL_UP)
        autoRepeat: false
        onActivated: {
            list.decrementCurrentIndex()
            sfxFocus.play()
        }
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.SCROLL_DOWN)
        autoRepeat: false
        onActivated: {
            list.incrementCurrentIndex()
            sfxFocus.play()
        }
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.BUTTON_SELECT)
        autoRepeat: false
        onActivated: {
            const item = list.currentItem.inventoryItem
            console.log(item.HandleID, item.text)
        }
    }
}
