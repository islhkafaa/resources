import QtQuick
import Resources

Item {
    id: root

    property string label: "Core 0"
    property real percentage: 0.0
    property color color: Theme.cpu

    width: 200
    height: 24

    Row {
        anchors.fill: parent
        spacing: Theme.spacingM

        Text {
            width: 50
            anchors.verticalCenter: parent.verticalCenter
            text: root.label
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeS
            font.weight: Theme.fontWeightMedium
            color: Theme.textSecondary
            horizontalAlignment: Text.AlignRight
        }

        Rectangle {
            width: parent.width - 50 - 45 - (Theme.spacingM * 2)
            height: 6
            anchors.verticalCenter: parent.verticalCenter
            radius: height / 2
            color: Theme.surfaceAlt

            Rectangle {
                width: parent.width * Math.max(0.0, Math.min(1.0, root.percentage))
                height: parent.height
                radius: parent.radius
                color: root.color

                Behavior on width { SmoothedAnimation { velocity: 200 } }
            }
        }

        Text {
            width: 45
            anchors.verticalCenter: parent.verticalCenter
            text: Math.round(root.percentage * 100) + "%"
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeS
            font.weight: Theme.fontWeightMedium
            color: Theme.textPrimary
            horizontalAlignment: Text.AlignRight
        }
    }
}
