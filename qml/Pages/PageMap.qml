import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtLocation
import QtPositioning

Page {
    property int subMenuCenter

    background: Rectangle { color: "black" }

    MapView {
        id: view
        anchors.fill: parent
        anchors.margins: 4
        map.plugin: Plugin {
            name: "osm"
            PluginParameter {
                name: "osm.mapping.custom.host";
                value: "https://tiles.stadiamaps.com/tiles/alidade_smooth_dark/%z/%x/%y.png?api_key=" + settings.mapApiKey
            }
        }
        map.onSupportedMapTypesChanged: {
            map.activeMapType = map.supportedMapTypes[map.supportedMapTypes.length - 1]
        }
        map.zoomLevel: 15
        map.center: QtPositioning.coordinate(42.463744, -71.359555) // Oslo
    }

    Image {
        source: "/images/map_marker.svg"
    }

    footer: Rectangle {
        height: 40
        color: "#00000000"

        RowLayout {
            spacing: 4
            height: parent.height
            anchors.left: parent.left
            anchors.right: parent.right

            Rectangle {
                Layout.preferredWidth: 180
                height: parent.height
                color: "#333"

                Text {
                    function getCurrentDate() {
                        return new Date().toLocaleDateString(Qt.locale("en_US"), "M.dd.yyyy")
                    }

                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: getCurrentDate()
                    color: "white"

                    Timer {
                        interval: 1000; running: true; repeat: true
                        onTriggered: parent.text = parent.getCurrentDate()
                    }
                }
            }

            Rectangle {
                Layout.preferredWidth: 180
                height: parent.height
                color: "#333"

                Text {
                    function getCurrentTime() {
                        return new Date().toLocaleTimeString(Qt.locale("en_US"), Locale.ShortFormat)
                    }

                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignLeft
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: getCurrentTime()
                    color: "white"

                    Timer {
                        interval: 1000; running: true; repeat: true
                        onTriggered: parent.text = parent.getCurrentTime()
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                height: parent.height
                color: "#333"

                Text {
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: "Wasteland"
                    color: "white"
                }
            }
        }
    }
}
