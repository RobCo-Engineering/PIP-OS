import QtQuick 2.15
import QtQuick.Controls

Page {
    property alias subMenuIndex: subMenu.currentIndex

    background: Rectangle { color: "black" }

    header: SubMenu {
        id: subMenu
        model: ["MAIN", "SIDE", "DAILY", "EVENT"]
        horizontalOffset: 78
    }

    footer: Rectangle {
        color: "grey"
        height: 40
    }
}
