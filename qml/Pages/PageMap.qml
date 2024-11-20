import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts
import QtMultimedia
import QtLocation
import QtPositioning

Page {
    id: root

    property int subMenuCenter

    background: Rectangle { color: "black" }

    // GPS positioning, source is defined in settings file
    PositionSource {
        id: posSource

        // https://doc.qt.io/qt-6/position-plugin-nmea.html
        name: "nmea"
        PluginParameter { name: "nmea.source"; value: settings.mapPositionSource }

        // TODO: If no source is defined maybe we can just use a static location file

        updateInterval: 1000
        active: true
        onPositionChanged: {
            // send the geocode request
            geocodeModel.query = position.coordinate
            geocodeModel.update()
        }
    }

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

        // Center map on the GPS position
        map.center: posSource.position.coordinate

        map.zoomLevel: 16
        map.maximumZoomLevel: 18
        map.minimumZoomLevel: 12
    }

    // This model will attempt to retrieve the address of the GPS location to display in the footer
    GeocodeModel {
        id: geocodeModel
        plugin: view.map.plugin
        onLocationsChanged:
        {
            if (count == 1) {
                var addr = get(0).address
                currentLocation.text = addr.district !== "" ? addr.district : addr.city
            }
        }
    }

    // Place the 'player icon' to show the player location
    MapItemView {
        parent: view.map
        model: geocodeModel
        delegate: pointDelegate
    }

    // TODO: Add optional config items for other icons, so you can add a home icon for example

    Component {
        id: pointDelegate

        MapQuickItem {
            id: point
            parent: view.map
            coordinate: posSource.position.coordinate
            anchorPoint.x: pointMarker.width/2
            anchorPoint.y: pointMarker.height/2
            sourceItem: Image {
                id: pointMarker
                source: "/assets/images/map_marker.svg"
                fillMode: Image.PreserveAspectFit
                height: 50; width: 50
            }
        }
    }

    // Grey out the screen if there's no signal
    Rectangle {
        visible: !posSource.valid
        anchors.fill: parent
        color: "black"
        opacity: 0.8
    }

    // Display "No Signal" text if there is no signal
    Text {
        visible: !posSource.valid
        anchors.fill: parent
        text: "No Signal..."
        font.pixelSize: 42
        ColorAnimation on color {
            loops: Animation.Infinite
            duration: 1000
            from: "transparent"
            to: "white"
        }
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
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
                    id: currentLocation
                    anchors.fill: parent
                    anchors.margins: 10
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignRight
                    font.pixelSize: 28
                    font.family: "Roboto Condensed Bold"
                    text: "-"
                    color: "white"
                }
            }
        }
    }

    SoundEffect {
        id: sfxFocus
        source: "/assets/sounds/item_focus.wav"
    }

    Connections {
        target: hid
        function onUserActivity(a) {
            switch(a) {
            case "SCROLL_UP":
                view.map.zoomLevel++
                sfxFocus.play()
                break
            case "SCROLL_DOWN":
                view.map.zoomLevel--
                sfxFocus.play()
                break
            }
        }
    }
}
