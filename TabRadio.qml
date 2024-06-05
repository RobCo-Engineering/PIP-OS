import QtQuick 2.15
import QtQuick.Layouts

Rectangle {
    id: radio
    color: "black"

    state: list.currentItem.stat

    property int activeStation: -1

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
            model: ["Appalachia Radio", "Classical Radio", "Pirate Radio"]
            spacing: 10
            delegate: RowLayout {
                id: item
                property variant stat: modelData
                property int thisIndex: index

                width: ListView.view.width

                Rectangle {
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    opacity: (thisIndex === activeStation) ? 1 : 0
                    width: 12
                    height: 12
                    Layout.leftMargin: 4
                }

                Text {
                    text: stat
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
        source: "/images/radio_axis.svg"
        fillMode: Image.PreserveAspectFit
        width: 220
    }

    Connections {
        target: inputHandler
        function onScrollUp() { list.incrementCurrentIndex() }
        function onScrollDown() { list.decrementCurrentIndex() }
        function onScrollPress() {
            if (list.currentIndex === activeStation) {
                activeStation = -1
            } else {
                activeStation = list.currentIndex
            }
        }
    }
}
