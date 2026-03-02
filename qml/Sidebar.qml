import QtQuick
import QtQuick.Controls.Basic
import QtQuick.Layouts
import Resources

Rectangle {
    id: root

    property int currentIndex: 0
    readonly property var navItems: [{
        "label": "Overview",
        "page": "pages/OverviewPage.qml",
        "color": Theme.accent
    }, {
        "label": "CPU",
        "page": "pages/CpuPage.qml",
        "color": Theme.cpu
    }, {
        "label": "Memory",
        "page": "pages/MemoryPage.qml",
        "color": Theme.memory
    }, {
        "label": "Disk",
        "page": "pages/DiskPage.qml",
        "color": Theme.disk
    }, {
        "label": "Network",
        "page": "",
        "color": Theme.net
    }, {
        "label": "GPU",
        "page": "",
        "color": Theme.gpu
    }, {
        "label": "Sensors",
        "page": "",
        "color": Theme.accent
    }]

    signal pageSelected(string page)

    color: Theme.surface

    Column {
        anchors.fill: parent

        Item {
            width: parent.width
            height: Theme.spacingL
        }

        Repeater {
            model: root.navItems

            SidebarItem {
                required property int index
                required property var modelData

                width: parent.width
                label: modelData.label
                accentColor: modelData.color
                selected: root.currentIndex === index
                onClicked: {
                    root.currentIndex = index;
                    if (modelData.page !== "")
                        root.pageSelected(modelData.page);

                }
            }

        }

    }

}
