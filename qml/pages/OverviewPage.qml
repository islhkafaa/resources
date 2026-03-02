import "../components"
import QtQuick
import QtQuick.Layouts
import Resources

Item {
    id: root

    function formatBytes(bytes) {
        if (bytes < 1024)
            return bytes.toFixed(1) + " B/s";

        if (bytes < 1024 * 1024)
            return (bytes / 1024).toFixed(1) + " KB/s";

        if (bytes < 1024 * 1024 * 1024)
            return (bytes / (1024 * 1024)).toFixed(1) + " MB/s";

        return (bytes / (1024 * 1024 * 1024)).toFixed(2) + " GB/s";
    }

    function primaryDisk() {
        return Monitor.disks.length > 0 ? Monitor.disks[0] : null;
    }

    function primaryNet() {
        for (let i = 0; i < Monitor.networks.length; ++i) {
            let n = Monitor.networks[i];
            if (n.rxBytesPerSec > 0 || n.txBytesPerSec > 0)
                return n;

        }
        return Monitor.networks.length > 0 ? Monitor.networks[0] : null;
    }

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
                title: "Overview"
                subtitle: Monitor.cpuModel || "System at a glance"
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
                    value: Monitor.cpuUsage.toFixed(1)
                    unit: "%"
                    accentColor: Theme.cpu
                    percentage: Monitor.cpuUsage / 100
                }

                MetricCard {
                    title: "Memory"
                    value: Monitor.memUsed.toFixed(1)
                    unit: "GB"
                    accentColor: Theme.memory
                    percentage: Monitor.memUsagePercent / 100
                    subtitle: Monitor.memTotal.toFixed(1) + " GB total"
                }

                MetricCard {
                    id: diskCard

                    property var d: primaryDisk()

                    title: "Disk"
                    value: d ? formatBytes(d.readBytesPerSec + d.writeBytesPerSec) : "--"
                    unit: ""
                    accentColor: Theme.disk
                    percentage: d ? d.usagePercent / 100 : 0
                    subtitle: d ? d.device : ""
                }

                MetricCard {
                    id: netCard

                    property var n: primaryNet()

                    title: "Network"
                    value: n ? formatBytes(n.rxBytesPerSec + n.txBytesPerSec) : "--"
                    unit: ""
                    accentColor: Theme.net
                    percentage: 0
                    subtitle: n ? n.iface : ""
                }

            }

            Column {
                width: parent.width
                spacing: Theme.spacingS

                Text {
                    text: "Memory"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeL
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }

                Rectangle {
                    width: parent.width
                    height: 72
                    radius: Theme.radiusMedium
                    color: Theme.surfaceAlt
                    border.color: Theme.border
                    border.width: 1

                    Row {
                        anchors.fill: parent
                        anchors.margins: Theme.spacingM
                        spacing: Theme.spacingXL

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Text {
                                text: Monitor.memUsed.toFixed(2) + " / " + Monitor.memTotal.toFixed(2) + " GB"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeM
                                font.weight: Theme.fontWeightMedium
                                color: Theme.textPrimary
                            }

                            Text {
                                text: "Physical memory"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeS
                                color: Theme.textSecondary
                            }

                        }

                        Column {
                            anchors.verticalCenter: parent.verticalCenter
                            spacing: 4

                            Text {
                                text: Monitor.swapUsed.toFixed(2) + " / " + Monitor.swapTotal.toFixed(2) + " GB"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeM
                                font.weight: Theme.fontWeightMedium
                                color: Theme.textPrimary
                            }

                            Text {
                                text: "Swap"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeS
                                color: Theme.textSecondary
                            }

                        }

                    }

                }

            }

        }

    }

}
