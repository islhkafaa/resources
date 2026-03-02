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
                    text: "Sensors"
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeXXL
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }

                Text {
                    text: Monitor.sensors.length + " thermal zones detected"
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

                Repeater {
                    model: Monitor.sensors

                    Rectangle {
                        width: 200
                        height: 100
                        color: Theme.surfaceAlt
                        border.color: Theme.border
                        border.width: 1
                        radius: Theme.radiusLarge

                        Column {
                            anchors.centerIn: parent
                            spacing: Theme.spacingS

                            Text {
                                text: modelData.name
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeS
                                font.weight: Theme.fontWeightMedium
                                font.letterSpacing: 0.6
                                color: Theme.textSecondary
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Row {
                                spacing: 2
                                anchors.horizontalCenter: parent.horizontalCenter

                                Text {
                                    // Critical (Red)

                                    id: tempText

                                    text: modelData.temperature.toFixed(1)
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeXXL
                                    font.weight: Theme.fontWeightSemiBold
                                    color: {
                                        var t = modelData.temperature;
                                        if (t < 40)
                                            return Theme.gpu;

                                        if (t < 60)
                                            return Theme.cpu;

                                        if (t < 80)
                                            return Theme.net;

                                        return "#ff4b4b";
                                    }
                                }

                                Text {
                                    text: "°C"
                                    anchors.baseline: tempText.baseline
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeM
                                    font.weight: Theme.fontWeightRegular
                                    color: Theme.textSecondary
                                }

                            }

                        }

                    }

                }

            }

        }

    }

}
