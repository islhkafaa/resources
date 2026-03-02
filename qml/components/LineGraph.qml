import QtQuick
import Resources

Item {
    id: root

    property var dataPoints: []
    property real maxValue: 100.0
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
                return;

            var points = root.dataPoints;
            var effectivePoints = points;
            if (points.length > 60) {
                effectivePoints = points.slice(points.length - 60);
            }

            var count = effectivePoints.length;
            if (count < 2) return;

            var stepX = width / 59.0;

            ctx.beginPath();

            var offsetX = width - ((count - 1) * stepX);

            var getTargetY = function(val) {
                var ratio = val / root.maxValue;
                ratio = Math.max(0.0, Math.min(1.0, ratio));
                return height - (ratio * height);
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

            ctx.lineTo(offsetX + ((count - 1) * stepX), height);
            ctx.lineTo(offsetX, height);
            ctx.closePath();

            var gradient = ctx.createLinearGradient(0, 0, 0, height);
            gradient.addColorStop(0, root.fillColor.toString());
            var fadeColor = Qt.rgba(root.fillColor.r, root.fillColor.g, root.fillColor.b, 0.0);
            gradient.addColorStop(1, fadeColor.toString());

            ctx.fillStyle = gradient;
            ctx.fill();
        }
    }
}
