import "../components"
import QtQuick
import QtQuick.Layouts
import Resources

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
                    text: "Memory"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeXXL
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }

                Text {
                    text: Monitor.memTotal.toFixed(1) + " GB Total Installed"
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
                layer.enabled: true

                Column {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: Theme.spacingM
                    spacing: 4
                    z: 2

                    Text {
                        text: "MEMORY USAGE"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeXS
                        font.weight: Theme.fontWeightMedium
                        font.letterSpacing: 0.6
                        color: Theme.textSecondary
                    }

                    Row {
                        spacing: 4

                        Text {
                            id: memUsageText

                            text: Monitor.memUsed.toFixed(1)
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeXXL
                            font.weight: Theme.fontWeightSemiBold
                            color: Theme.textPrimary
                        }

                        Text {
                            text: "GB (" + Monitor.memUsagePercent.toFixed(0) + "%)"
                            anchors.baseline: memUsageText.baseline
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeM
                            font.weight: Theme.fontWeightRegular
                            color: Theme.textSecondary
                        }

                    }

                }

                LineGraph {
                    anchors.fill: parent
                    anchors.margins: Theme.spacingM
                    dataPoints: Monitor.memHistory
                    maxValue: 100
                    lineColor: Theme.memory
                    lineWidth: 3
                }

            }

            Rectangle {
                width: parent.width
                height: 200
                color: Theme.surfaceAlt
                border.color: Theme.border
                border.width: 1
                radius: Theme.radiusLarge
                clip: true
                layer.enabled: true

                Column {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.margins: Theme.spacingM
                    spacing: 4
                    z: 2

                    Text {
                        text: "SWAP USAGE"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeXS
                        font.weight: Theme.fontWeightMedium
                        font.letterSpacing: 0.6
                        color: Theme.textSecondary
                    }

                    Row {
                        spacing: 4

                        Text {
                            id: swapUsageText

                            text: Monitor.swapUsed.toFixed(1)
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeXXL
                            font.weight: Theme.fontWeightSemiBold
                            color: Theme.textPrimary
                        }

                        Text {
                            text: "GB"
                            anchors.baseline: swapUsageText.baseline
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeM
                            font.weight: Theme.fontWeightRegular
                            color: Theme.textSecondary
                        }

                    }

                }

                LineGraph {
                    anchors.fill: parent
                    anchors.margins: Theme.spacingM
                    dataPoints: Monitor.swapHistory
                    maxValue: 100
                    lineColor: Theme.disk
                    lineWidth: 3
                }

            }

            Column {
                width: parent.width
                spacing: Theme.spacingM

                Text {
                    text: "Details"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeL
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }

                Flow {
                    width: parent.width
                    spacing: Theme.spacingXL

                    Column {
                        spacing: 2

                        Text {
                            text: "In Use"
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeS
                            color: Theme.textSecondary
                        }

                        Text {
                            text: Monitor.memUsed.toFixed(1) + " GB"
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeL
                            font.weight: Theme.fontWeightMedium
                            color: Theme.textPrimary
                        }

                    }

                    Column {
                        spacing: 2

                        Text {
                            text: "Available"
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeS
                            color: Theme.textSecondary
                        }

                        Text {
                            text: Monitor.memAvailable.toFixed(1) + " GB"
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeL
                            font.weight: Theme.fontWeightMedium
                            color: Theme.textPrimary
                        }

                    }

                    Column {
                        spacing: 2

                        Text {
                            text: "Swap Used"
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeS
                            color: Theme.textSecondary
                        }

                        Text {
                            text: Monitor.swapUsed.toFixed(1) + " / " + Monitor.swapTotal.toFixed(1) + " GB"
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeL
                            font.weight: Theme.fontWeightMedium
                            color: Theme.textPrimary
                        }

                    }

                }

            }

        }

    }

}
