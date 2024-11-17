import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import "qml/Layout" as Layout

Window {
    id: root
    width: 730
    height: 600
    visible: true
    title: qsTr("PIP-OS V7.1.0.8")
    color: "black"

    // property alias appContext: app

    Layout.MainState {
        id: main
        width: 730
        height: 600
        transform: [
            Scale {
                id: scale;
                xScale: yScale;
                yScale: Math.min(root.width/main.width, root.height/main.height) * settings.scale
            },
            Translate {
                x: settings.xOffset
                y: settings.yOffset
            }
        ]
    }
}
