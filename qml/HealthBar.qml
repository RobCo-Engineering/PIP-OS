import QtQuick

Rectangle {
    id: root
    height: 10
    width: 100

    property real progress: 0.5

    border.color: "white"
    border.width: 2
    color: "#00000000"

    Rectangle {
        anchors.left: root.left
        anchors.verticalCenter: root.verticalCenter
        height: parent.height - parent.border.width
        width: root.width * progress
    }
}
