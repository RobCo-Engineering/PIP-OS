import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia

import "../../Components"

Rectangle {
    id: root
    color: "black"

    property var radioStations: {
        "Appalachia Radio": "https://fallout.fm:8444/falloutfm10.ogg",
        "Classical Radio": "https://fallout.fm:8444/falloutfm9.ogg",
        "Diamond City Radio": "https://fallout.fm:8444/falloutfm6.ogg",
        "More Where That Came From": "https://fallout.fm:8444/falloutfm8.ogg",
        "Galaxy News Radio": "https://fallout.fm:8444/falloutfm2.ogg",
        "Radio New Vegas": "https://fallout.fm:8444/falloutfm3.ogg"
    }

    Rectangle {
        id: listMain
        color: "black"
        anchors {
            top: root.top
            topMargin: 40
            left: root.left
            bottom: root.bottom
        }
        width: root.width / 2

        ListView {
            id: list
            anchors.fill: parent
            model: Object.keys(root.radioStations)
            spacing: 10
            delegate: RowLayout {
                id: item

                property string station: modelData
                property bool active: root.radioStations[station] == Radio.source

                width: ListView.view.width

                Rectangle {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    opacity: item.active ? 1 : 0
                    Layout.preferredWidth: 12
                    Layout.preferredHeight: 12
                    Layout.leftMargin: 4
                }

                Text {
                    text: item.station
                    color: item.ListView.isCurrentItem ? "black" : "white"
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

    Image {
        id: radioAxis
        anchors {
            top: listMain.top
            right: root.right
            rightMargin: 20
        }
        source: "/images/radio_axis.svg"
        fillMode: Image.PreserveAspectFit
        width: 220

        FrequencyGraph {
            id: graph
            active: Radio.playing
            anchors.fill: radioAxis
        }
    }

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
            if (root.radioStations[list.currentItem.station] == Radio.source) {
                // Turn off the radio if the already playing station is clicked
                Radio.setSource("")
                Radio.stop()
            } else {
                // Play the selected station
                Radio.setSource(radioStations[list.currentItem.station])
                Radio.play()
            }
        }
    }
}
