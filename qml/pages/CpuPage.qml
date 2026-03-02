import QtQuick
import QtQuick.Layouts
import Resources
import "../components"

Item {
    id: root
    anchors.fill: parent

    Flickable {
        anchors.fill: parent
        contentHeight: contentColumn.height + Theme.spacingXL * 2
        clip: true

        Column {
            id: contentColumn
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: Theme.spacingXL
            anchors.leftMargin: Theme.spacingXL
            anchors.rightMargin: Theme.spacingXL
            spacing: Theme.spacingL

            Column {
                spacing: Theme.spacingXS

                Text {
                    text: "Processor"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeXXL
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }

                Text {
                    text: Monitor.cpuModel || "Unknown Processor"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeM
                    font.weight: Theme.fontWeightRegular
                    color: Theme.textSecondary
                }
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.border
            }

            Rectangle {
                width: parent.width
                height: 300
                color: Theme.surfaceAlt
                border.color: Theme.border
                border.width: 1
                radius: Theme.radiusLarge
                clip: true

                Column {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: Theme.spacingM
                    spacing: 4
                    z: 2

                    Text {
                        text: "OVERALL UTILIZATION"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeXS
                        font.weight: Theme.fontWeightMedium
                        font.letterSpacing: 0.6
                        color: Theme.textSecondary
                    }

                    Row {
                        spacing: 4

                        Text {
                            id: usageText
                            text: Monitor.cpuUsage.toFixed(1)
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeXXL
                            font.weight: Theme.fontWeightSemiBold
                            color: Theme.textPrimary
                        }
                        Text {
                            text: "%"
                            anchors.baseline: usageText.baseline
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeM
                            font.weight: Theme.fontWeightRegular
                            color: Theme.textSecondary
                        }
                    }
                }

                LineGraph {
                    anchors.fill: parent
                    dataPoints: Monitor.cpuHistory
                    maxValue: 100.0
                    lineColor: Theme.cpu
                    lineWidth: 3
                }
            }

            Column {
                width: parent.width
                spacing: Theme.spacingM

                Text {
                    text: "Logical Processors (" + Monitor.cpuCores + ")"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeL
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }

                Flow {
                    width: parent.width
                    spacing: Theme.spacingM

                    Repeater {
                        model: Monitor.perCoreUsage
                        CoreBar {
                            label: "Core " + index
                            percentage: modelData / 100.0
                            color: Theme.cpu
                        }
                    }
                }
            }
        }
    }
}
