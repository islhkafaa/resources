import "../components"
import QtQuick
import QtQuick.Controls
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
                title: "Processes"
                subtitle: Monitor.processes.length + " Processes running"
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.border
            }

            DashboardCard {
                width: parent.width
                height: 600
                title: "PROCESS LIST"

                Column {
                    id: processListColumn

                    anchors.fill: parent
                    anchors.margins: Theme.spacingM
                    spacing: Theme.spacingS

                    Rectangle {
                        width: processListColumn.width
                        height: 30
                        color: Theme.surface
                        radius: Theme.radiusSmall

                        RowLayout {
                            anchors.fill: parent
                            anchors.leftMargin: Theme.spacingS
                            anchors.rightMargin: Theme.spacingS

                            Text {
                                text: "PID"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeS
                                font.weight: Theme.fontWeightMedium
                                color: Theme.textSecondary
                                Layout.preferredWidth: 60
                            }

                            Text {
                                text: "USER"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeS
                                font.weight: Theme.fontWeightMedium
                                color: Theme.textSecondary
                                Layout.preferredWidth: 100
                            }

                            Text {
                                text: "NAME"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeS
                                font.weight: Theme.fontWeightMedium
                                color: Theme.textSecondary
                                Layout.fillWidth: true
                            }

                            Text {
                                text: "CPU %"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeS
                                font.weight: Theme.fontWeightMedium
                                color: Theme.textSecondary
                                Layout.preferredWidth: 80
                                horizontalAlignment: Text.AlignRight
                            }

                            Text {
                                text: "MEM"
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeS
                                font.weight: Theme.fontWeightMedium
                                color: Theme.textSecondary
                                Layout.preferredWidth: 80
                                horizontalAlignment: Text.AlignRight
                            }

                        }

                    }

                    ListView {
                        id: processListView

                        width: processListColumn.width
                        height: processListColumn.height - 30 - Theme.spacingS
                        clip: true
                        model: Monitor.processes

                        delegate: Rectangle {
                            width: processListView.width
                            height: 36
                            color: index % 2 === 0 ? "transparent" : Qt.rgba(1, 1, 1, 0.02)
                            radius: Theme.radiusSmall

                            RowLayout {
                                anchors.fill: parent
                                anchors.leftMargin: Theme.spacingS
                                anchors.rightMargin: Theme.spacingS

                                Text {
                                    text: modelData.pid
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeM
                                    color: Theme.textPrimary
                                    Layout.preferredWidth: 60
                                }

                                Text {
                                    text: modelData.user
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeM
                                    color: Theme.textSecondary
                                    Layout.preferredWidth: 100
                                }

                                Text {
                                    text: modelData.name
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeM
                                    font.weight: Theme.fontWeightMedium
                                    color: Theme.textPrimary
                                    Layout.fillWidth: true
                                    elide: Text.ElideRight
                                }

                                Text {
                                    text: modelData.cpuUsage.toFixed(1) + " %"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeM
                                    color: Theme.textPrimary
                                    Layout.preferredWidth: 80
                                    horizontalAlignment: Text.AlignRight
                                }

                                Text {
                                    text: modelData.memUsageMb.toFixed(1) + " MB"
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeM
                                    color: Theme.textPrimary
                                    Layout.preferredWidth: 80
                                    horizontalAlignment: Text.AlignRight
                                }

                            }

                        }

                    }

                }

            }

        }

    }

}
