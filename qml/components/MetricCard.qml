import QtQuick
import QtQuick.Layouts
import Resources

Item {
    id: root

    property string title: ""
    property string value: "--"
    property string unit: ""
    property color accentColor: Theme.accent
    property real percentage: 0.0

    width: 280
    height: 140

    Rectangle {
        anchors.fill: parent
        radius: Theme.radiusMedium
        color: Theme.surfaceAlt
        border.color: Theme.border
        border.width: 1

        Rectangle {
            anchors.fill: parent
            radius: parent.radius
            color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.03)
        }

        Column {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.margins: Theme.spacingM
            spacing: Theme.spacingXS

            Row {
                spacing: Theme.spacingS
                anchors.left: parent.left

                Text {
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeS
                    font.weight: Theme.fontWeightMedium
                    font.letterSpacing: 0.6
                    color: Theme.textSecondary
                    text: root.title.toUpperCase()
                }
            }

            Row {
                anchors.left: parent.left
                spacing: 4
                baseline: children[0].baseline

                Text {
                    text: root.value
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeXXL
                    font.weight: Theme.fontWeightSemiBold
                    color: Theme.textPrimary
                }

                Text {
                    text: root.unit
                    font.family: Theme.fontFamily
                    font.pixelSize: Theme.fontSizeM
                    font.weight: Theme.fontWeightRegular
                    color: Theme.textSecondary
                    topPadding: 12
                }
            }
        }

        Rectangle {
            id: sparklineBg
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.leftMargin: Theme.spacingM
            anchors.rightMargin: Theme.spacingM
            anchors.bottomMargin: Theme.spacingM
            height: 32
            radius: Theme.radiusSmall
            color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.07)

            Rectangle {
                width: parent.width * Math.max(0.0, Math.min(1.0, root.percentage))
                height: parent.height
                radius: parent.radius
                color: Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.2)

                Behavior on width { SmoothedAnimation { velocity: 60 } }
            }

            Text {
                anchors.right: parent.right
                anchors.verticalCenter: parent.verticalCenter
                anchors.rightMargin: Theme.spacingS
                text: Math.round(root.percentage * 100) + "%"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeXS
                font.weight: Theme.fontWeightMedium
                color: root.accentColor
                opacity: 0.8
            }
        }
    }
}
