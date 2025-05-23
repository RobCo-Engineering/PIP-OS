import QtQuick
import QtMultimedia
import PipOS

Rectangle {
    id: collections
    color: "black"

    Rectangle {
        id: listMain
        color: "black"
        anchors {
            top: collections.top
            topMargin: 20
            left: collections.left
            bottom: collections.bottom
        }
        width: collections.width / 2

        ListView {
            id: list
            anchors.fill: parent
            spacing: 5
            model: Dweller.collections
            delegate: Item {
                id: item
                property variant ci: modelData

                height: 34
                width: parent.width

                Text {
                    anchors {
                        left: parent.left
                        leftMargin: 10
                    }
                    text: ci.name
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    font.family: "Roboto Condensed"
                    font.pixelSize: 26
                }

                Text {
                    anchors {
                        right: parent.right
                        rightMargin: 10
                    }
                    text: ci.quantity
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    font.family: "Roboto Condensed"
                    font.pixelSize: 26
                    horizontalAlignment: Text.AlignRight
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

    SoundEffect {
        id: sfxFocus
        source: "/sounds/item_focus.wav"
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.SCROLL_UP)
        enabled: collections.enabled
        autoRepeat: false
        onActivated: {
            list.decrementCurrentIndex()
            sfxFocus.play()
        }
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.SCROLL_DOWN)
        enabled: collections.enabled
        autoRepeat: false
        onActivated: {
            list.incrementCurrentIndex()
            sfxFocus.play()
        }
    }

    onEnabledChanged: {

        // Reset page state on enabled
    }
}
