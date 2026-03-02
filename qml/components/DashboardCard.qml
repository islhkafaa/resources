import QtQuick
import Resources

Rectangle {
    id: root

    property string title: ""
    default property alias internalContent: container.data

    color: Theme.surfaceAlt
    border.color: Theme.border
    border.width: 1
    radius: Theme.radiusLarge
    clip: true
    layer.enabled: true

    Column {
        anchors.fill: parent
        anchors.margins: Theme.spacingM
        spacing: Theme.spacingS

        Text {
            visible: root.title.length > 0
            text: root.title.toUpperCase()
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeXS
            font.weight: Theme.fontWeightMedium
            font.letterSpacing: 0.6
            color: Theme.textSecondary
            z: 2
        }

        Item {
            id: container

            width: parent.width
            height: parent.height - (root.title.length > 0 ? (parent.spacing + parent.children[0].height) : 0)
        }

    }

}
