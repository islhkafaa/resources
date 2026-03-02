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
                title: "Processor"
                subtitle: Monitor.cpuModel || "Unknown Processor"
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.border
            }

            DashboardCard {
                width: parent.width
                height: 300
                title: "OVERALL UTILIZATION"

                Row {
                    spacing: 4
                    z: 2

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

                LineGraph {
                    anchors.fill: parent
                    dataPoints: Monitor.cpuHistory
                    maxValue: 100
                    lineColor: Theme.cpu
                    lineWidth: 3
                }

            }

            DashboardCard {
                width: parent.width
                height: coreFlow.height + Theme.spacingXL + 30
                title: "LOGICAL PROCESSORS (" + Monitor.cpuCores + ")"

                Flow {
                    id: coreFlow

                    width: parent.width
                    spacing: Theme.spacingM

                    Repeater {
                        model: Monitor.perCoreUsage

                        CoreBar {
                            label: "Core " + index
                            percentage: modelData / 100
                            color: Theme.cpu
                        }

                    }

                }

            }

        }

    }

}
