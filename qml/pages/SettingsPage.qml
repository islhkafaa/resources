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
                title: "Settings"
                subtitle: "Application preferences"
            }

            Rectangle {
                width: parent.width
                height: 1
                color: Theme.border
            }

            DashboardCard {
                width: parent.width
                height: settingsFlow.height + Theme.spacingXL + 30
                title: "GENERAL"

                Flow {
                    id: settingsFlow

                    width: parent.width
                    spacing: Theme.spacingM

                    Column {
                        spacing: Theme.spacingS

                        Text {
                            text: "Update Interval"
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeM
                            font.weight: Theme.fontWeightMedium
                            color: Theme.textPrimary
                        }

                        Text {
                            text: "How often the system monitor polls for new data."
                            font.family: Theme.fontFamily
                            font.pixelSize: Theme.fontSizeS
                            color: Theme.textSecondary
                        }

                        Item {
                            width: 1
                            height: Theme.spacingXS
                        }

                        ComboBox {
                            id: intervalCombo

                            width: 200
                            model: ["Fast (500ms)", "Normal (1000ms)", "Slow (2000ms)", "Very Slow (5000ms)"]
                            currentIndex: {
                                let val = Monitor.updateInterval;
                                if (val <= 500)
                                    return 0;

                                if (val <= 1000)
                                    return 1;

                                if (val <= 2000)
                                    return 2;

                                return 3;
                            }
                            onActivated: {
                                let val = 1000;
                                if (currentIndex === 0)
                                    val = 500;
                                else if (currentIndex === 1)
                                    val = 1000;
                                else if (currentIndex === 2)
                                    val = 2000;
                                else if (currentIndex === 3)
                                    val = 5000;
                                Monitor.updateInterval = val;
                            }

                            delegate: ItemDelegate {
                                width: intervalCombo.width
                                highlighted: intervalCombo.highlightedIndex === index

                                contentItem: Text {
                                    text: modelData
                                    color: highlighted ? Theme.textPrimary : Theme.textSecondary
                                    font.family: Theme.fontFamily
                                    font.pixelSize: Theme.fontSizeM
                                    elide: Text.ElideRight
                                    verticalAlignment: Text.AlignVCenter
                                }

                                background: Rectangle {
                                    color: highlighted ? Theme.accentDim : "transparent"
                                }

                            }

                            indicator: Canvas {
                                id: canvas

                                x: intervalCombo.width - width - intervalCombo.rightPadding
                                y: intervalCombo.topPadding + (intervalCombo.availableHeight - height) / 2
                                width: 12
                                height: 8
                                contextType: "2d"
                                onPaint: {
                                    context.reset();
                                    context.moveTo(0, 0);
                                    context.lineTo(width, 0);
                                    context.lineTo(width / 2, height);
                                    context.closePath();
                                    context.fillStyle = intervalCombo.pressed ? Theme.accent : Theme.textSecondary;
                                    context.fill();
                                }

                                Connections {
                                    function onPressedChanged() {
                                        canvas.requestPaint();
                                    }

                                    target: intervalCombo
                                }

                            }

                            contentItem: Text {
                                leftPadding: Theme.spacingS
                                rightPadding: intervalCombo.indicator.width + intervalCombo.spacing
                                text: intervalCombo.displayText
                                font.family: Theme.fontFamily
                                font.pixelSize: Theme.fontSizeM
                                color: intervalCombo.pressed ? Theme.accent : Theme.textPrimary
                                verticalAlignment: Text.AlignVCenter
                                elide: Text.ElideRight
                            }

                            background: Rectangle {
                                implicitWidth: 120
                                implicitHeight: 40
                                border.color: intervalCombo.pressed ? Theme.accent : Theme.border
                                border.width: intervalCombo.visualFocus ? 2 : 1
                                color: Theme.surface
                                radius: Theme.radiusSmall
                            }

                            popup: Popup {
                                y: intervalCombo.height + 1
                                width: intervalCombo.width
                                implicitHeight: contentItem.implicitHeight
                                padding: 1

                                contentItem: ListView {
                                    clip: true
                                    implicitHeight: contentHeight
                                    model: intervalCombo.popup.visible ? intervalCombo.delegateModel : null
                                    currentIndex: intervalCombo.highlightedIndex

                                    ScrollIndicator.vertical: ScrollIndicator {
                                    }

                                }

                                background: Rectangle {
                                    border.color: Theme.border
                                    color: Theme.surfaceAlt
                                    radius: Theme.radiusSmall
                                }

                            }

                        }

                    }

                }

            }

        }

    }

}
