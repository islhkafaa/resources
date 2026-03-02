pragma Singleton

import QtQml
import QtQuick

QtObject {
    readonly property color bg:            "#0d0d0f"
    readonly property color surface:       "#111114"
    readonly property color surfaceAlt:    "#17171b"
    readonly property color border:        "#1f1f26"
    readonly property color borderSubtle:  "#191920"

    readonly property color accent:        "#5c6fff"
    readonly property color accentHover:   "#7080ff"
    readonly property color accentDim:     "#2a2f6e"

    readonly property color textPrimary:   "#e8e8f0"
    readonly property color textSecondary: "#8888a0"
    readonly property color textDisabled:  "#44445a"

    readonly property color cpu:    "#7c6fff"
    readonly property color memory: "#ff6b9d"
    readonly property color disk:   "#00c4a0"
    readonly property color net:    "#ffaa3b"
    readonly property color gpu:    "#3bbfff"

    readonly property int radiusSmall:  6
    readonly property int radiusMedium: 12
    readonly property int radiusLarge:  18

    readonly property int spacingXS: 4
    readonly property int spacingS:  8
    readonly property int spacingM:  16
    readonly property int spacingL:  24
    readonly property int spacingXL: 40

    readonly property int fontSizeXS:   10
    readonly property int fontSizeS:    12
    readonly property int fontSizeM:    14
    readonly property int fontSizeL:    18
    readonly property int fontSizeXL:   24
    readonly property int fontSizeXXL:  32

    readonly property int fontWeightRegular:  400
    readonly property int fontWeightMedium:   500
    readonly property int fontWeightSemiBold: 600

    readonly property string fontFamily: "Inter"

    readonly property int sidebarWidth:    220
    readonly property int titleBarHeight:  44
}
