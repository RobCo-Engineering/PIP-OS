import QtQuick
import QtGraphs

Item {
    id: root

    property bool active: true

    GraphsView {
        id: graphView
        anchors.fill: parent
        anchors.leftMargin: -77
        anchors.rightMargin: -5
        anchors.bottomMargin: -40

        theme: GraphsTheme {
            backgroundVisible: false
            plotAreaBackgroundColor: "#11000000"
        }

        axisX: ValueAxis {
            min: 0
            max: 100
            lineVisible: false
            gridVisible: false
            subGridVisible: false
            labelsVisible: false
            visible: false
            id: xAxis
        }

        axisY: ValueAxis {
            min: -1.5
            max: 1.5
            lineVisible: false
            gridVisible: false
            subGridVisible: false
            labelsVisible: false
            visible: false
            id: yAxis
        }

        SplineSeries {
            id: splineSeries
        }

        Item {
            id: data

            property int skipPoints: 4
            property int windowSize: 100
            property int currentX: 0

            FrameAnimation {
                running: true
                onTriggered: {
                    if (currentFrame % 2 == 0) return

                    // Remove old points
                    if (splineSeries.count >= data.windowSize / data.skipPoints) {
                        splineSeries.remove(0)
                    }

                    // Only add points at intervals, let spline interpolate between them
                    if (data.currentX % data.skipPoints === 0) {
                        if (root.active) splineSeries.append(data.currentX, (Math.random() - 0.5) * 2)
                        else splineSeries.append(data.currentX, 0)
                    }

                    // Update scrolling window
                    data.currentX++
                    xAxis.min = data.currentX - data.windowSize
                    xAxis.max = data.currentX
                }
            }
        }
    }
}
