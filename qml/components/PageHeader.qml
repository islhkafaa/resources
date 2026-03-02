import QtQuick
import Resources

Item {
    id: root

    property string title: ""
    property string subtitle: ""

    width: parent.width
    height: contentColumn.height

    Column {
        id: contentColumn

        width: parent.width
        spacing: Theme.spacingXS

        Text {
            text: root.title
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeXXL
            font.weight: Theme.fontWeightSemiBold
            color: Theme.textPrimary
        }

        Text {
            visible: root.subtitle.length > 0
            text: root.subtitle
            font.family: Theme.fontFamily
            font.pixelSize: Theme.fontSizeM
            font.weight: Theme.fontWeightRegular
            color: Theme.textSecondary
        }

    }

}
