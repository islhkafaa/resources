import "../components"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Resources

Item {
    id: root

    property int currentDiskIndex: 0
    property var currentDisk: Monitor.disks.length > 0 ? Monitor.disks[currentDiskIndex] : null

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
                title: "Disk"
                subtitle: Monitor.disks.length + " Storage Devices Detected"
            }

            Row {
                spacing: Theme.spacingM

                Repeater {
                    model: Monitor.disks

                    Rectangle {
                        width: 100
                        height: 32
                        radius: Theme.radiusSmall
                        color: root.currentDiskIndex === index ? Theme.accent : Theme.surfaceAlt
                        border.color: root.currentDiskIndex === index ? Theme.accentHover : Theme.border
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData.device
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeS
                            font.weight: Theme.fontWeightMedium
                            color: root.currentDiskIndex === index ? "#ffffff" : Theme.textSecondary
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.currentDiskIndex = index
                            cursorShape: Qt.PointingHandCursor
                        }

                    }

                }

            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.border
            }

            DashboardCard {
                width: parent.width
                height: 250
                title: "READ THROUGHPUT"

                Row {
                    spacing: 4
                    z: 2

                    Text {
                        id: readText

                        text: root.currentDisk ? (root.currentDisk.readBytesPerSec / (1024 * 1024)).toFixed(1) : "0.0"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeXXL
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                    }

                    Text {
                        text: "MB/s"
                        anchors.baseline: readText.baseline
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                        font.weight: Theme.fontWeightRegular
                        color: Theme.textSecondary
                    }

                }

                LineGraph {
                    anchors.fill: parent
                    dataPoints: root.currentDisk ? root.currentDisk.readHistory : []
                    autoScale: true
                    lineColor: Theme.disk
                    lineWidth: 3
                }

            }

            DashboardCard {
                width: parent.width
                height: 250
                title: "WRITE THROUGHPUT"

                Row {
                    spacing: 4
                    z: 2

                    Text {
                        id: writeText

                        text: root.currentDisk ? (root.currentDisk.writeBytesPerSec / (1024 * 1024)).toFixed(1) : "0.0"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeXXL
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                    }

                    Text {
                        text: "MB/s"
                        anchors.baseline: writeText.baseline
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                        font.weight: Theme.fontWeightRegular
                        color: Theme.textSecondary
                    }

                }

                LineGraph {
                    anchors.fill: parent
                    dataPoints: root.currentDisk ? root.currentDisk.writeHistory : []
                    autoScale: true
                    lineColor: Theme.accent
                    lineWidth: 3
                }

            }

        }

    }

}
