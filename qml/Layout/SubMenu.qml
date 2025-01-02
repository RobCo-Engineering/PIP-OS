import QtQuick
import QtMultimedia
import PipOS

ListView {
    id: list

    property int centerPoint: 0

    signal goNext

    Component.onCompleted: {
        list.goNext.connect(goToNext)
    }

    function goToNext() {
        if (currentIndex + 1 === model.length)
            currentIndex = 0
        else
            currentIndex = currentIndex + 1
        sfxRotary.play()
    }

    function goToPrevious() {
        if (currentIndex - 1 < 0)
            currentIndex = model.length - 1
        else
            currentIndex = currentIndex - 1
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
        opacity: 1.0 - ((index - list.currentIndex)
                        > 0 ? (index - list.currentIndex) : (list.currentIndex - index)) * 0.34
    }

    // Debug selected item
    // highlight: Rectangle {
    //     border.color: "grey"
    //     border.width: 2
    //     color: "black"
    // }

    // Sound effect for sub tab change
    SoundEffect {
        id: sfxRotary
        source: "/sounds/horizontal_tab.wav"
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.SUB_TAB_NEXT)
        autoRepeat: false
        onActivated: {
            list.goToNext()
            sfxRotary.play()
        }
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.SUB_TAB_PREVIOUS)
        autoRepeat: false
        onActivated: {
            list.goToPrevious()
            sfxRotary.play()
        }
    }
}
