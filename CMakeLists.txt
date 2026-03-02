cmake_minimum_required(VERSION 3.22)

project(Resources VERSION 0.1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Core Quick QuickControls2 Svg)

qt_standard_project_setup(REQUIRES 6.4)
qt_policy(SET QTP0001 NEW)
qt_policy(SET QTP0004 NEW)

qt_add_executable(resources
    src/main.cpp
    src/systemmonitor.cpp
    src/linux/cpureader.cpp
    src/linux/memreader.cpp
    src/linux/diskreader.cpp
    src/linux/netreader.cpp
    src/linux/sensorsreader.cpp
)

target_include_directories(resources PRIVATE src)

set_source_files_properties(qml/Theme.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(resources
    URI Resources
    VERSION 1.0
    QML_FILES
        qml/App.qml
        qml/Sidebar.qml
        qml/SidebarItem.qml
        qml/Theme.qml
        qml/pages/OverviewPage.qml
        qml/pages/CpuPage.qml
        qml/pages/MemoryPage.qml
        qml/pages/DiskPage.qml
        qml/pages/NetworkPage.qml
        qml/pages/SensorsPage.qml
        qml/components/PageHeader.qml
        qml/components/DashboardCard.qml
        qml/components/MetricCard.qml
        qml/components/LineGraph.qml
        qml/components/CoreBar.qml
    RESOURCES
        assets/fonts/Inter-Regular.ttf
        assets/fonts/Inter-Medium.ttf
        assets/fonts/Inter-SemiBold.ttf
)

set_target_properties(resources PROPERTIES
    WIN32_EXECUTABLE TRUE
    MACOSX_BUNDLE TRUE
)

target_link_libraries(resources PRIVATE
    Qt6::Core
    Qt6::Quick
    Qt6::QuickControls2
    Qt6::Svg
)

include(GNUInstallDirs)
install(TARGETS resources
    BUNDLE  DESTINATION .
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
