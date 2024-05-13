import QtQuick 2.15

ListView {
    id: list

    property int horizontalOffset: 0

    signal goNext()

    Component.onCompleted: {
        list.goNext.connect(goToNext)
    }

    function goToNext() {
        if (currentIndex + 1 === items.length) currentIndex = 0
        else currentIndex = currentIndex + 1
    }

    function goToStart() { currentIndex = 0 }

    orientation: ListView.Horizontal
    spacing: 20
    height:60

    highlightRangeMode: ListView.StrictlyEnforceRange
    preferredHighlightBegin: (width / 2) - (currentItem.width / 2) + horizontalOffset
    preferredHighlightEnd: (width / 2) + (currentItem.width / 2) + horizontalOffset

    delegate: Text {
        text: modelData
        color: "white"
        font.family: "Roboto Condensed"
        height: 60
        verticalAlignment: Text.AlignBottom
        width: implicitWidth
        font.pixelSize: 32
        opacity: 1.0 - ((index - list.currentIndex) > 0 ? (index - list.currentIndex) : (list.currentIndex - index)) * 0.32
    }

    // Debug selected item
    // highlight: Rectangle {
    //     border.color: "grey"
    //     border.width: 2
    //     color: "black"
    // }
}

