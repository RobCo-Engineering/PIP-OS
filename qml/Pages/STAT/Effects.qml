import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    color: "black"

    // TODO: Vertical centered instead of top aligned
    ColumnLayout {
        anchors {
            top: root.top
            topMargin: 30
            left: root.left
            right: root.right
        }

        RowLayout {
            Rectangle {
                color: "#333"
                width: 50
                height: 50
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    source: "/images/hydration.svg"
                    fillMode: Image.PreserveAspectFit
                    height: 25
                }
                Text {
                    anchors.bottom: parent.bottom
                    text: "75%"
                    color: "white"
                    font.family: "Roboto Condensed"
                    font.pixelSize: 20
                    width: parent.width
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            Rectangle {
                color: "#333"
                height: 50
                Layout.fillWidth: true

                Text {
                    text: "Well Hydrated:"
                    color: "white"
                    font.family: "Roboto Condensed"
                    font.pixelSize: 24
                    height: parent.height
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: 10
                }

                Text {
                    anchors.right: parent.right
                    text: "AP REGEN +25%  DISEASE RESISTANCE +25%"
                    color: "white"
                    font.family: "Roboto Condensed Bold"
                    font.pixelSize: 24
                    height: parent.height
                    horizontalAlignment: Text.AlignRight
                    verticalAlignment: Text.AlignVCenter
                    rightPadding: 10
                }
            }
        }
    }
}
