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
        "page": "pages/NetworkPage.qml",
        "color": Theme.net
    }, {
        "label": "Processes",
        "page": "pages/ProcessesPage.qml",
        "color": Theme.cpu
    }, {
        "label": "Sensors",
        "page": "pages/SensorsPage.qml",
        "color": Theme.accent
    }, {
        "label": "Settings",
        "page": "pages/SettingsPage.qml",
        "color": Theme.textSecondary
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
            model: root.navItems.length - 1

            SidebarItem {
                required property int index
                property var modelData: root.navItems[index]

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

    SidebarItem {
        id: settingsItem

        property int index: root.navItems.length - 1
        property var modelData: root.navItems[index]

        anchors.bottom: parent.bottom
        anchors.bottomMargin: Theme.spacingL
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
