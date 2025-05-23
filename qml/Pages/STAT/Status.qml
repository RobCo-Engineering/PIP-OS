import QtQuick
import PipOS 1.0

import "../"

Item {
    id: root

    HealthBar {
        progress: Dweller.healthHead
        width: 40
        height: 10
        anchors {
            horizontalCenter: root.horizontalCenter
            verticalCenter: root.verticalCenter
            verticalCenterOffset: -210
        }
    }

    HealthBar {
        progress: Dweller.healthBody
        width: 40
        height: 10
        anchors {
            horizontalCenter: root.horizontalCenter
            verticalCenter: root.verticalCenter
            verticalCenterOffset: 76
        }
    }

    HealthBar {
        progress: Dweller.healthLeftArm
        width: 40
        height: 10
        anchors {
            horizontalCenter: root.horizontalCenter
            horizontalCenterOffset: -130
            verticalCenter: root.verticalCenter
            verticalCenterOffset: -105
        }
    }

    HealthBar {
        progress: Dweller.healthRightArm
        width: 40
        height: 10
        anchors {
            horizontalCenter: root.horizontalCenter
            horizontalCenterOffset: 120
            verticalCenter: root.verticalCenter
            verticalCenterOffset: -105
        }
    }

    HealthBar {
        progress: Dweller.healthLeftLeg
        width: 40
        height: 10
        anchors {
            horizontalCenter: root.horizontalCenter
            horizontalCenterOffset: -130
            verticalCenter: root.verticalCenter
            verticalCenterOffset: 30
        }
    }

    HealthBar {
        progress: Dweller.healthRightLeg
        width: 40
        height: 10
        anchors {
            horizontalCenter: root.horizontalCenter
            horizontalCenterOffset: 120
            verticalCenter: root.verticalCenter
            verticalCenterOffset: 30
        }
    }

    AnimatedImage {
        id: vaultboy
        anchors {
            horizontalCenter: root.horizontalCenter
            verticalCenter: root.verticalCenter
            verticalCenterOffset: -55
        }
        source: "/images/status_ok.gif"
    }

    Row {
        anchors {
            horizontalCenter: root.horizontalCenter
            bottom: dwellerName.top
            bottomMargin: 20
        }
        height: 64
        width: weapon_stats.width + armor_stats.width + 20
        spacing: 20

        // Weapon stats
        ItemStat {
            id: weapon_stats
            itemIcon: "/images/status/weapon.svg"
            itemStats: ListModel {
                ListElement {
                    icon: "/images/status/damage.svg"
                    value: 88
                }

                ListElement {
                    icon: "/images/status/energy.svg"
                    value: 88
                }

                ListElement {
                    icon: "/images/status/radiation.svg"
                    value: 75
                }
            }
        }

        // Armor stats
        ItemStat {
            id: armor_stats
            itemIcon: "/images/status/armor.svg"
            itemStats: ListModel {
                ListElement {
                    icon: "/images/status/defence.svg"
                    value: 145
                }

                ListElement {
                    icon: "/images/status/poison.svg"
                    value: 5
                }

                ListElement {
                    icon: "/images/status/energy.svg"
                    value: 116
                }
            }
        }
    }

    Text {
        id: dwellerName
        text: Dweller.name
        anchors {
            horizontalCenter: root.horizontalCenter
            bottom: root.bottom
            bottomMargin: 26
        }
        font {
            family: "Roboto Condensed"
            pixelSize: 26
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        width: 300
        height: 22
        color: "white"
    }
}
