import QtQuick 2.15
import QtMultimedia

ListView {
    id: list

    property int centerPoint: 0

    signal goNext()

    Component.onCompleted: {
        list.goNext.connect(goToNext)
    }

    function goToNext() {
        if (currentIndex + 1 === model.length) currentIndex = 0
        else currentIndex = currentIndex + 1
        sfxRotary.play()
    }

    function goToPrevious() {
        if (currentIndex - 1 < 0) currentIndex = model.length - 1
        else currentIndex = currentIndex - 1
        sfxRotary.play()
    }

    function goToStart() {
        currentIndex = 0
        sfxRotary.play()
    }

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
        opacity: 1.0 - ((index - list.currentIndex) > 0 ? (index - list.currentIndex) : (list.currentIndex - index)) * 0.34
    }

    SoundEffect {
        id: sfxRotary
        source: "/assets/sounds/horizontal_tab.wav"
    }

    // Debug selected item
    // highlight: Rectangle {
    //     border.color: "grey"
    //     border.width: 2
    //     color: "black"
    // }

    Connections {
        target: hid
        function onUserActivity(a) {
            if (a.startsWith("SUB_TAB_")) {
                switch (a) {
                case "SUB_TAB_NEXT":
                    list.goToNext()
                    sfxRotary.play()
                    break
                case "SUB_TAB_PREVIOUS":
                    list.goToPrevious()
                    sfxRotary.play()
                    break
                }
            }
        }
    }
}
