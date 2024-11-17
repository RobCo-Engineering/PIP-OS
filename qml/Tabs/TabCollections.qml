import QtQuick 2.15
import QtMultimedia


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
            model: dweller.collections
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
            highlight: Rectangle { color: "white" }
            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightFollowsCurrentItem: true
            preferredHighlightBegin: 0
            preferredHighlightEnd: list.bottom
            clip: true
        }
    }

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
            }
        }
    }
}
