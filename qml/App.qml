import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Resources

ApplicationWindow {
    id: root
    visible: true
    width: 1280
    height: 800
    minimumWidth: 960
    minimumHeight: 600
    title: "Resources"
    color: Theme.bg

    FontLoader {
        id: fontRegular
        source: "../assets/fonts/Inter-Regular.ttf"
    }
    FontLoader {
        id: fontMedium
        source: "../assets/fonts/Inter-Medium.ttf"
    }
    FontLoader {
        id: fontSemiBold
        source: "../assets/fonts/Inter-SemiBold.ttf"
    }

    Rectangle {
        id: titleBar
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right
        height: Theme.titleBarHeight
        color: Theme.surface
        z: 10

        Rectangle {
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            height: 1
            color: Theme.border
        }

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: Theme.spacingL
            anchors.rightMargin: Theme.spacingL
            spacing: Theme.spacingS

            Text {
                text: "Resources"
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeM
                font.weight: Theme.fontWeightSemiBold
                font.letterSpacing: 0.3
                color: Theme.textPrimary
            }

            Item { Layout.fillWidth: true }

            Text {
                text: Qt.formatDateTime(new Date(), "ddd, MMM d  HH:mm:ss")
                font.family: Theme.fontFamily
                font.pixelSize: Theme.fontSizeS
                font.weight: Theme.fontWeightRegular
                color: Theme.textSecondary

                Timer {
                    interval: 1000
                    running: true
                    repeat: true
                    onTriggered: parent.text = Qt.formatDateTime(new Date(), "ddd, MMM d  HH:mm:ss")
                }
            }
        }
    }

    Row {
        anchors.top: titleBar.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Sidebar {
            id: sidebar
            width: Theme.sidebarWidth
            height: parent.height
            onPageSelected: function(page) {
                contentLoader.source = page
            }
        }

        Rectangle {
            width: 1
            height: parent.height
            color: Theme.border
        }

        Item {
            width: parent.width - Theme.sidebarWidth - 1
            height: parent.height

            Loader {
                id: contentLoader
                anchors.fill: parent
                source: "pages/OverviewPage.qml"
            }
        }
    }
}
