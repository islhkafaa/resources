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

            PageHeader {
                title: "Memory"
                subtitle: Monitor.memTotal.toFixed(1) + " GB Total Installed"
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.border
            }

            DashboardCard {
                width: parent.width
                height: 300
                title: "MEMORY USAGE"

                Row {
                    spacing: 4
                    z: 2

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

                LineGraph {
                    anchors.fill: parent
                    dataPoints: Monitor.memHistory
                    maxValue: 100
                    lineColor: Theme.memory
                    lineWidth: 3
                }

            }

            DashboardCard {
                width: parent.width
                height: 200
                title: "SWAP USAGE"

                Row {
                    spacing: 4
                    z: 2

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

                LineGraph {
                    anchors.fill: parent
                    dataPoints: Monitor.swapHistory
                    maxValue: 100
                    lineColor: Theme.disk
                    lineWidth: 3
                }

            }

            DashboardCard {
                width: parent.width
                height: detailsFlow.height + Theme.spacingXL + 30
                title: "DETAILS"

                Flow {
                    id: detailsFlow

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
