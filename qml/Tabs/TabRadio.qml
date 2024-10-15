import QtQuick 2.15
import QtQuick.Layouts
import QtMultimedia
import Qt.labs.folderlistmodel 2.7
import PipOS 1.0

Rectangle {
    id: radio
    color: "black"

    property string activeStation

    FolderListModel {
        id: sourceFolder
        nameFilters: ["*.wav"]
        folder: App.settings.radioStationLocation
        showDirs: false
        showOnlyReadable: true
    }

    Rectangle {
        id: listMain
        color: "black"
        anchors {
            top: radio.top
            topMargin: 40
            left: radio.left
            bottom: radio.bottom
        }
        width: radio.width / 2

        ListView {
            id: list
            anchors.fill: parent
            model: sourceFolder
            spacing: 10
            delegate: RowLayout {
                id: item
                required property string fileName
                property string station: fileName.replace(/\.[^/.]+$/, "")

                width: ListView.view.width

                Rectangle {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    opacity: (station === activeStation) ? 1 : 0
                    width: 12
                    height: 12
                    Layout.leftMargin: 4
                }

                Text {
                    text: station
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
            right: radio.right
            rightMargin: 20
        }
        source: "/assets/images/radio_axis.svg"
        fillMode: Image.PreserveAspectFit
        width: 220
    }

    MediaPlayer {
        id: playRadio
        source: ""
        audioOutput: AudioOutput {}
    }

    Component.onCompleted: {
        console.log("Loading wav files from", App.settings.radioStationLocation)
    }

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
                if (list.currentItem.station === activeStation) {
                    // Turn off the radio if the already playing station is clicked
                    activeStation = -1
                    playRadio.source = ""
                    playRadio.stop()
                } else {
                    // Play the selected station
                    activeStation = list.currentItem.station
                    playRadio.source = sourceFolder.get(list.currentIndex, 'filePath')
                    playRadio.play()
                }
                break
            }
        }
    }
}
