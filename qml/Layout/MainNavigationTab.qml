import QtQuick

Rectangle {
    id: root

    color: "#000000000"
    property bool active: true
    property string text

    Rectangle {
        visible: root.active
        anchors {
            horizontalCenter: tabText.horizontalCenter
            top: tabText.top
            topMargin: 20
        }

        width: tabText.implicitWidth + 16
        height: 50
        border.color: "white"
        border.width: 1
        color: "#000000000"

        // Blank out a portion of the outline
        Rectangle {
            anchors {
                top: parent.top
                horizontalCenter: parent.horizontalCenter
            }
            width: tabText.implicitWidth + 2
            height: 2
            color: "black"
        }

        // TODO: Clip off the bottom of the box too
    }

    Text {
        id: tabText
        anchors.fill: parent
        text: root.text
        color: "white"
        font {
            family: "Roboto Condensed Bold"
            pixelSize: 32
        }
        horizontalAlignment: Text.AlignHCenter
    }
}
