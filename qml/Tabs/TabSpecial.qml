import QtQuick 2.15
import QtQuick.Layouts
import PipOS 1.0

Rectangle {
    id: root
    color: "black"

    state: specialList.currentItem.stat

    Rectangle {
        id: listMain
        color: "black"
        anchors {
            top: root.top
            topMargin: 20
            left: root.left
            // leftMargin: 10
            bottom: root.bottom
            // bottomMargin: 60
        }
        width: root.width/2

        ListView {
            id: specialList
            anchors.fill: parent
            spacing: 5
            model: ["Strength", "Perception", "Endurance", "Charisma", "Intelligence", "Agility", "Luck"]
            delegate: Item {
                id: item
                property variant stat: modelData

                height: 34
                width: parent.width

                Text {
                    anchors {
                        left: parent.left
                        leftMargin: 10
                    }
                    text: stat
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    font.family: "Roboto Condensed"
                    font.pixelSize: 26
                }

                Text {
                    anchors {
                        right: parent.right
                        rightMargin: 10
                    }
                    text: App.dweller["special" + stat]
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    font.family: "Roboto Condensed"
                    font.pixelSize: 26
                    horizontalAlignment: Text.AlignRight
                }
            }
            highlight: Rectangle { color: "white" }
            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightFollowsCurrentItem: true
            preferredHighlightBegin: 0
            preferredHighlightEnd: specialList.bottom
            clip: true
        }
    }

    Rectangle {
        color: "black"
        clip: true
        anchors {
            top: root.top
            left: listMain.right
            leftMargin: 20
            right: root.right
            bottom: root.bottom
            bottomMargin: 60
        }

        // TODO: GIF seems to cut short on loop
        AnimatedImage {
            id: specialAnimation
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            // source: "/assets/images/%1.gif".arg(list.currentItem.stat)
            sourceSize.width: 550
            sourceSize.height: 400
            sourceClipRect: Qt.rect(125,50,280,280)
            height: 350
        }

        Text {
            id: specialDescription
            anchors.top: specialAnimation.bottom
            text: ""
            color: "white"
            font.family: "Roboto Condensed"
            font.pixelSize: 22
            width: parent.width
            wrapMode: Text.WordWrap
        }
    }

    states: [
        State {
            name: "Strength"
            PropertyChanges {
                target: specialDescription
                text: "Strength is a measure of your raw physical power. It affects how much you can carry, and the damage of all melee attacks."
            }
            PropertyChanges {
                target: specialAnimation
                source: "/assets/images/Strength"
            }
        },
        State {
            name: "Perception"
            PropertyChanges {
                target: specialDescription
                text: "Perception affects your awareness of nearby enemies, your ability to detect stealthy movement, and your weapon accuracy in V.A.T.S."
            }
            PropertyChanges {
                target: specialAnimation
                source: "/assets/images/Perception"
            }
        },
        State {
            name: "Endurance"
            PropertyChanges {
                target: specialDescription
                text: "Endurance is a measure of your overall physical fitness. It affects your total Health, the Action Point drain from sprinting, and your resistance to disease."
            }
            PropertyChanges {
                target: specialAnimation
                source: "/assets/images/Endurance"
            }
        },
        State {
            name: "Charisma"
            PropertyChanges {
                target: specialDescription
                text: "Charisma is your ability to lead and help others. It allows you to share higher point perk cards and prices when you barter."
            }
            PropertyChanges {
                target: specialAnimation
                source: "/assets/images/Charisma"
            }
        },
        State {
            name: "Intelligence"
            PropertyChanges {
                target: specialDescription
                text: "Intelligence is a measure of your overall mental acuity, and affects your ability to hack terminals, the condition and durability of items that you craft (Fusion/Plasma Core) and experience when you kill creatures."
            }
            PropertyChanges {
                target: specialAnimation
                source: "/assets/images/Intelligence"
            }
        },
        State {
            name: "Agility"
            PropertyChanges {
                target: specialDescription
                text: "Agility is a measure of your overall finesse and reflexes. It affects the number of Action Points in V.A.T.S. and your ability to sneak."
            }
            PropertyChanges {
                target: specialAnimation
                source: "/assets/images/Agility"
            }
        },
        State {
            name: "Luck"
            PropertyChanges {
                target: specialDescription
                text: "Luck is a measure of your general good fortune, and affects the recharge rate of Critical Hits as well as the condition and durability of items that you loot."
            }
            PropertyChanges {
                target: specialAnimation
                source: "/assets/images/Luck"
            }
        }

    ]

    Connections {
        target: App.hid
        function onUserActivity(a) {
            switch(a) {
            case "SCROLL_UP":
                specialList.decrementCurrentIndex()
                break
            case "SCROLL_DOWN":
                specialList.incrementCurrentIndex()
                break
            }
        }
    }
}
