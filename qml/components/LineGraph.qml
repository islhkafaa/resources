import QtQuick
import Resources

Item {
    id: root

    property var dataPoints: []
    property real maxValue: 100
    property bool autoScale: false
    property color lineColor: Theme.accent
    property color fillColor: Qt.rgba(lineColor.r, lineColor.g, lineColor.b, 0.2)
    property int lineWidth: 2

    onDataPointsChanged: canvas.requestPaint()
    onWidthChanged: canvas.requestPaint()
    onHeightChanged: canvas.requestPaint()

    Canvas {
        id: canvas

        anchors.fill: parent
        antialiasing: true
        onPaint: {
            var ctx = getContext("2d");
            ctx.clearRect(0, 0, width, height);
            if (!root.dataPoints || root.dataPoints.length === 0)
                return ;

            var points = root.dataPoints;
            var effectivePoints = points;
            if (points.length > 60)
                effectivePoints = points.slice(points.length - 60);

            var count = effectivePoints.length;
            if (count < 2)
                return ;

            var activeMax = root.maxValue;
            if (root.autoScale) {
                var localMax = 0;
                for (var j = 0; j < count; ++j) {
                    if (effectivePoints[j] > localMax)
                        localMax = effectivePoints[j];

                }
                activeMax = Math.max(localMax * 1.1, 1);
            }
            var drawWidth = width - 4;
            var drawHeight = height - 4;
            var stepX = drawWidth / 59;
            ctx.beginPath();
            var offsetX = 2 + (drawWidth - ((count - 1) * stepX));
            var getTargetY = function getTargetY(val) {
                var ratio = activeMax > 0 ? val / activeMax : 0;
                ratio = Math.max(0, Math.min(1, ratio));
                return 2 + (drawHeight - (ratio * drawHeight));
            };
            var startY = getTargetY(effectivePoints[0]);
            ctx.moveTo(offsetX, startY);
            for (var i = 1; i < count; i++) {
                var x = offsetX + (i * stepX);
                var y = getTargetY(effectivePoints[i]);
                ctx.lineTo(x, y);
            }
            ctx.lineWidth = root.lineWidth;
            ctx.strokeStyle = root.lineColor.toString();
            ctx.lineJoin = 'round';
            ctx.stroke();
            ctx.lineTo(offsetX + ((count - 1) * stepX), height - 1);
            ctx.lineTo(offsetX, height - 1);
            ctx.closePath();
            var gradient = ctx.createLinearGradient(0, 0, 0, height);
            gradient.addColorStop(0, root.fillColor.toString());
            var fadeColor = Qt.rgba(root.fillColor.r, root.fillColor.g, root.fillColor.b, 0);
            gradient.addColorStop(1, fadeColor.toString());
            ctx.fillStyle = gradient;
            ctx.fill();
        }
    }

}
