import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts

import "../Layout"
import "../Tabs"

Page {
    id: root

    background: Rectangle { color: "black" }

    AnimatedImage {
        anchors {
            fill: parent
            leftMargin: -100
            rightMargin: -300
            topMargin: -10
        }

        source: "/images/AtomicCommandStart.gif"
        fillMode: Image.PreserveAspectCrop
        verticalAlignment: Image.AlignTop
    }
}
