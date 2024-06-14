import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import QtQuick.Effects

Window {
    id: win
    width: 730
    height: 600
    visible: true
    title: qsTr("PIP-OS V7.1.0.8")

    color: "black"
    MainState {
        id: main
        width: 730
        height: 600
        transform: [
            Scale {
                id: scale; xScale: yScale;
                yScale: Math.min(win.width/main.width, win.height/main.height)
            },
            Translate {
                x: (win.width-main.width*scale.xScale)/2;
                y: (win.height-main.height*scale.yScale)/2;
            }
        ]
    }
}
