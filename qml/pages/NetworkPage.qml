import "../components"
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Resources

Item {
    id: root

    property int currentNetIndex: 0
    property var currentNet: Monitor.networks.length > 0 ? Monitor.networks[currentNetIndex] : null

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
                title: "Network"
                subtitle: Monitor.networks.length + " Interfaces Detected"
            }

            Row {
                spacing: Theme.spacingM

                Repeater {
                    model: Monitor.networks

                    Rectangle {
                        width: 100
                        height: 32
                        radius: Theme.radiusSmall
                        color: root.currentNetIndex === index ? Theme.net : Theme.surfaceAlt
                        border.color: root.currentNetIndex === index ? Qt.lighter(Theme.net, 1.2) : Theme.border
                        border.width: 1

                        Text {
                            anchors.centerIn: parent
                            text: modelData.iface
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeS
                            font.weight: Theme.fontWeightMedium
                            color: root.currentNetIndex === index ? "#ffffff" : Theme.textSecondary
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.currentNetIndex = index
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
                title: "RECEIVE (RX)"

                Row {
                    spacing: 4
                    z: 2

                    Text {
                        id: rxText

                        text: root.currentNet ? ((root.currentNet.rxBytesPerSec * 8) / 1e+06).toFixed(1) : "0.0"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeXXL
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                    }

                    Text {
                        text: "Mbps"
                        anchors.baseline: rxText.baseline
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                        font.weight: Theme.fontWeightRegular
                        color: Theme.textSecondary
                    }

                }

                LineGraph {
                    anchors.fill: parent
                    dataPoints: root.currentNet ? root.currentNet.rxHistory : []
                    autoScale: true
                    lineColor: Theme.net
                    lineWidth: 3
                }

            }

            DashboardCard {
                width: parent.width
                height: 250
                title: "TRANSMIT (TX)"

                Row {
                    spacing: 4
                    z: 2

                    Text {
                        id: txText

                        text: root.currentNet ? ((root.currentNet.txBytesPerSec * 8) / 1e+06).toFixed(1) : "0.0"
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeXXL
                        font.weight: Theme.fontWeightSemiBold
                        color: Theme.textPrimary
                    }

                    Text {
                        text: "Mbps"
                        anchors.baseline: txText.baseline
                        font.family: Theme.fontFamily
                        font.pixelSize: Theme.fontSizeM
                        font.weight: Theme.fontWeightRegular
                        color: Theme.textSecondary
                    }

                }

                LineGraph {
                    anchors.fill: parent
                    dataPoints: root.currentNet ? root.currentNet.txHistory : []
                    autoScale: true
                    lineColor: Theme.accent
                    lineWidth: 3
                }

            }

        }

    }

}
