import QtQuick
import QtMultimedia
import PipOS

Rectangle {
    id: root
    color: "black"

    state: list.currentItem.modelData

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
        width: root.width / 2

        ListView {
            id: list
            anchors.fill: parent
            spacing: 5
            model: ["Strength", "Perception", "Endurance", "Charisma", "Intelligence", "Agility", "Luck"]
            delegate: Item {
                id: item
                required property variant modelData

                height: 34
                width: parent.width

                Text {
                    anchors {
                        left: parent.left
                        leftMargin: 10
                    }
                    text: item.modelData
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    font.family: "Roboto Condensed"
                    font.pixelSize: 26
                }

                Text {
                    anchors {
                        right: parent.right
                        rightMargin: 10
                    }
                    text: Dweller["special" + item.modelData]
                    color: item.ListView.isCurrentItem ? "black" : "white"
                    font.family: "Roboto Condensed"
                    font.pixelSize: 26
                    horizontalAlignment: Text.AlignRight
                }
            }
            highlight: Rectangle {
                color: "white"
            }
            highlightRangeMode: ListView.StrictlyEnforceRange
            highlightFollowsCurrentItem: true
            preferredHighlightBegin: 0
            preferredHighlightEnd: list.bottom
            clip: true
        }
    }

    Rectangle {
        color: "black"
        clip: true
        anchors {
            top: root.top
            topMargin: -42
            left: listMain.right
            leftMargin: 20
            right: root.right
            bottom: root.bottom
            // bottomMargin: 60
        }

        // TODO: GIF seems to cut short on loop
        AnimatedImage {
            id: specialAnimation
            anchors.horizontalCenter: parent.horizontalCenter
            fillMode: Image.PreserveAspectFit
            sourceSize.width: 550
            sourceSize.height: 400
            sourceClipRect: Qt.rect(125, 50, 280, 280)
            height: 350
        }

        Text {
            id: specialDescription
            anchors.top: specialAnimation.bottom
            anchors.topMargin: -40
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
                specialDescription.text: "Strength is a measure of your raw physical power. It affects how much you can carry, and the damage of all melee attacks."
                specialAnimation.source: "/images/SPECIAL/Strength"
            }
        },
        State {
            name: "Perception"
            PropertyChanges {
                specialDescription.text: "Perception affects your awareness of nearby enemies, your ability to detect stealthy movement, and your weapon accuracy in V.A.T.S."
                specialAnimation.source: "/images/SPECIAL/Perception"
            }
        },
        State {
            name: "Endurance"
            PropertyChanges {
                specialDescription.text: "Endurance is a measure of your overall physical fitness. It affects your total Health, the Action Point drain from sprinting, and your resistance to disease."
                specialAnimation.source: "/images/SPECIAL/Endurance"
            }
        },
        State {
            name: "Charisma"
            PropertyChanges {
                specialDescription.text: "Charisma is your ability to lead and help others. It allows you to share higher point perk cards and prices when you barter."
                specialAnimation.source: "/images/SPECIAL/Charisma"
            }
        },
        State {
            name: "Intelligence"
            PropertyChanges {
                specialDescription.text: "Intelligence is a measure of your overall mental acuity, and affects your ability to hack terminals, the condition and durability of items that you craft (Fusion/Plasma Core) and experience when you kill creatures."
                specialAnimation.source: "/images/SPECIAL/Intelligence"
            }
        },
        State {
            name: "Agility"
            PropertyChanges {
                specialDescription.text: "Agility is a measure of your overall finesse and reflexes. It affects the number of Action Points in V.A.T.S. and your ability to sneak."
                specialAnimation.source: "/images/SPECIAL/Agility"
            }
        },
        State {
            name: "Luck"
            PropertyChanges {
                specialDescription.text: "Luck is a measure of your general good fortune, and affects the recharge rate of Critical Hits as well as the condition and durability of items that you loot."
                specialAnimation.source: "/images/SPECIAL/Luck"
            }
        }
    ]

    SoundEffect {
        id: sfxFocus
        source: "/sounds/item_focus.wav"
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.SCROLL_UP)
        enabled: root.enabled
        autoRepeat: false
        onActivated: {
            list.decrementCurrentIndex()
            sfxFocus.play()
        }
    }

    Shortcut {
        sequence: Settings.getKeySequence(Events.SCROLL_DOWN)
        enabled: root.enabled
        autoRepeat: false
        onActivated: {
            list.incrementCurrentIndex()
            sfxFocus.play()
        }
    }

    onEnabledChanged: {
        // Reset page state on enabled
    }
}
