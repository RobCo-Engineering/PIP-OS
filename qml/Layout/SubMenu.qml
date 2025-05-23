import QtQuick
import PipOS

ListView {
    id: list

    property int centerPoint: 0

    orientation: ListView.Horizontal
    spacing: 20
    height: 42

    highlightRangeMode: ListView.StrictlyEnforceRange
    preferredHighlightBegin: centerPoint - (currentItem.width / 2)
    preferredHighlightEnd: centerPoint + (currentItem.width / 2)
    highlightResizeDuration: 0

    delegate: Text {
        required property string modelData
        required property int index

        text: modelData
        color: "white"
        font.family: "Roboto Condensed"
        height: list.height
        verticalAlignment: Text.AlignBottom
        width: implicitWidth
        font.pixelSize: 32
        opacity: 1.0 - ((index - list.currentIndex)
                        > 0 ? (index - list.currentIndex) : (list.currentIndex - index)) * 0.34
    }

    // Debug selected item
    // highlight: Rectangle {
    //     border.color: "grey"
    //     border.width: 2
    //     color: "black"
    // }
}
