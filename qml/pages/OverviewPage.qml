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
                    text: "Overview"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeXXL
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }

                Text {
                    text: "System at a glance"
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

            Flow {
                width: parent.width
                spacing: Theme.spacingM

                MetricCard {
                    title: "CPU"
                    value: "--"
                    unit: "%"
                    accentColor: Theme.cpu
                    percentage: 0.0
                }

                MetricCard {
                    title: "Memory"
                    value: "--"
                    unit: "GB"
                    accentColor: Theme.memory
                    percentage: 0.0
                }

                MetricCard {
                    title: "Disk"
                    value: "--"
                    unit: "MB/s"
                    accentColor: Theme.disk
                    percentage: 0.0
                }

                MetricCard {
                    title: "Network"
                    value: "--"
                    unit: "Mb/s"
                    accentColor: Theme.net
                    percentage: 0.0
                }
            }

            Column {
                width: parent.width
                spacing: Theme.spacingS

                Text {
                    text: "Hardware"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeL
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }

                Rectangle {
                    width: parent.width
                    height: 100
                    radius: Theme.radiusMedium
                    color: Theme.surfaceAlt
                    border.color: Theme.border
                    border.width: 1

                    Text {
                        anchors.centerIn: parent
                        text: "Hardware info will appear here in Phase 2"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                        color: Theme.textDisabled
                    }
                }
            }
        }
    }
}
