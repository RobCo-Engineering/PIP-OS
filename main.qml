import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

import PipOS
import "qml/Layout" as Layout

Window {
    id: win
    width: 730
    height: 600
    visible: true
    title: qsTr("PIP-OS V7.1.0.8")
    color: "black"

    Layout.MainState {
        id: main
        width: 730
        height: 600
        transform: [
            Scale {
                id: scale;
                xScale: yScale;
                yScale: Math.min(win.width/main.width, win.height/main.height) * App.settings.scale
            },
            Translate {
                x: App.settings.xOffset
                y: App.settings.yOffset
            }
        ]
    }
}
