import QtQuick
import QtQuick.Layouts
import QtMultimedia



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
                property bool active: root.radioStations[station] == radio.source

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

    Image {
        id: radioAxis
        anchors {
            top: listMain.top
            right: root.right
            rightMargin: 20
        }
        source: "/assets/images/radio_axis.svg"
        fillMode: Image.PreserveAspectFit
        width: 220

        FrequencyGraph {
            id: graph
            active: radio.playing
            anchors.fill: radioAxis
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

            case "BUTTON_SELECT":
                if (root.radioStations[list.currentItem.station] == radio.source) {
                    // Turn off the radio if the already playing station is clicked
                    radio.setSource("")
                    radio.stop()
                } else {
                    // Play the selected station
                    radio.setSource(radioStations[list.currentItem.station])
                    radio.play()
                }
                break
            }
        }
    }
}
