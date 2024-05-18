import QtQuick 2.15

Item {
    id: root
    width: childrenRect.width
    height: 64
    required property string itemIcon
    required property ListModel itemStats

    Row {
        spacing: 5
        Rectangle {
            width: 64
            height: root.height
            color: "#333"
            Image {
                source: itemIcon
                fillMode: Image.PreserveAspectFit
                width: parent.width - 12
                height: parent.height - 12
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
            }
        }

        Repeater {
            model: itemStats
            Rectangle {
                required property string icon
                required property int value

                height: root.height
                width: 44
                color: "#333"

                Image {
                    source: icon
                    width: parent.width
                    anchors.top: parent.top
                    anchors.topMargin: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    fillMode: Image.PreserveAspectFit
                }

                Text {
                    text: value
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "Roboto Condensed Bold"
                    font.pixelSize: 28
                    horizontalAlignment: Text.AlignHCenter
                    color: "white"
                }
            }
        }
    }
}
