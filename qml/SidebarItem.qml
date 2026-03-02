import QtQuick
import QtQuick.Controls.Basic
import Resources

Item {
    id: root

    property string label: ""
    property bool selected: false
    property color accentColor: Theme.accent

    signal clicked()

    width: parent ? parent.width : 220
    height: 44

    Rectangle {
        id: bg
        anchors.fill: parent
        anchors.leftMargin: Theme.spacingS
        anchors.rightMargin: Theme.spacingS
        radius: Theme.radiusSmall
        color: root.selected
               ? Qt.rgba(root.accentColor.r, root.accentColor.g, root.accentColor.b, 0.12)
               : (hoverHandler.hovered
                    ? Qt.rgba(1, 1, 1, 0.04)
                    : "transparent")

        Behavior on color { ColorAnimation { duration: 120 } }

        Rectangle {
            visible: root.selected
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: -Theme.spacingS
            width: 3
            height: 22
            radius: 2
            color: root.accentColor

            Behavior on color { ColorAnimation { duration: 150 } }
        }

        Row {
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: Theme.spacingM
            spacing: Theme.spacingM

            Text {
                text: root.label
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeM
                font.weight: root.selected ? Theme.fontWeightMedium : Theme.fontWeightRegular
                color: root.selected ? Theme.textPrimary : Theme.textSecondary

                Behavior on color { ColorAnimation { duration: 120 } }
            }
        }
    }

    HoverHandler { id: hoverHandler }

    TapHandler {
        onTapped: root.clicked()
    }
}
