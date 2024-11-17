import QtQuick 6.5
import QtQuick.Layouts
import QtMultimedia

import "../"

Item {
    id: root

    HealthBar {
        progress: dweller.healthHead
        width: 40
        height: 10
        anchors{
            horizontalCenter: root.horizontalCenter
            verticalCenter: root.verticalCenter
            verticalCenterOffset: -210
        }
    }

    HealthBar {
        progress: dweller.healthBody
        width: 40
        height: 10
        anchors{
            horizontalCenter: root.horizontalCenter
            verticalCenter: root.verticalCenter
            verticalCenterOffset: 76
        }
    }

    HealthBar {
        progress: dweller.healthLeftArm
        width: 40
        height: 10
        anchors{
            horizontalCenter: root.horizontalCenter
            horizontalCenterOffset: -130
            verticalCenter: root.verticalCenter
            verticalCenterOffset: -105
        }
    }

    HealthBar {
        progress: dweller.healthRightArm
        width: 40
        height: 10
        anchors{
            horizontalCenter: root.horizontalCenter
            horizontalCenterOffset: 120
            verticalCenter: root.verticalCenter
            verticalCenterOffset: -105
        }
    }

    HealthBar {
        progress: dweller.healthLeftLeg
        width: 40
        height: 10
        anchors{
            horizontalCenter: root.horizontalCenter
            horizontalCenterOffset: -130
            verticalCenter: root.verticalCenter
            verticalCenterOffset: 30
        }
    }

    HealthBar {
        progress: dweller.healthRightLeg
        width: 40
        height: 10
        anchors{
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
         source: "/assets/images/status_ok.gif"
    }

    // AnimatedSprite {
    //     id: vaultboy
    //     anchors {
    //         horizontalCenter: root.horizontalCenter
    //         verticalCenter: root.verticalCenter
    //         verticalCenterOffset: -55
    //     }
    //     source: "/assets/images/status_normal.png"
    //     frameRate: 4
    //     interpolate: false
    //     frameWidth: 120
    //     frameHeight: 250
    //     frameCount: 8
    // }

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
            itemIcon: "/assets/images/weapon.svg"
            itemStats: ListModel {
                ListElement {
                    icon: "/assets/images/defence.svg"
                    value: 18
                }
            }
        }

        // Armor stats
        ItemStat {
            id: armor_stats
            itemIcon: "/assets/images/armor.svg"
            itemStats: ListModel {
                ListElement {
                    icon: "/assets/images/defence.svg"
                    value: 10
                }
            }
        }
    }

    Text {
        id: dwellerName
        text: dweller.name
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
