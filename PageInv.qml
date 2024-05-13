import QtQuick 2.15
import QtQuick.Controls

Page {
    property alias subMenuIndex: subMenu.currentIndex

    background: Rectangle { color: "black" }

    header: SubMenu {
        id: subMenu
        model: ["NEW", "WEAPONS", "ARMOR", "APPAREL", "FOOD/DRINK", "AID", "MISC", "HOLO", "NOTES", "JUNK", "MODS", "AMMO"]
        horizontalOffset: -76
    }

    footer: Rectangle {
        color: "grey"
        height: 40
    }
}
