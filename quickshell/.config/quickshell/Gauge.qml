import QtQuick
import Qt5Compat.GraphicalEffects

Item {
    id: root
    property real value: 0.0 // 0.0 to 1.0
    property color color: "#7aa2f7"
    
    implicitWidth: 20
    implicitHeight: 20

    Canvas {
        id: canvas
        anchors.fill: parent
        antialiasing: true

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.clearRect(0, 0, width, height);

            var centerX = width / 2;
            var centerY = height / 2;
            var radius = (width / 2) - 5;

            // 1. Draw Background Track
            ctx.beginPath();
            ctx.strokeStyle = "#444b6a";
            ctx.lineWidth = 4;
            ctx.arc(centerX, centerY, radius, 0, 2 * Math.PI);
            ctx.stroke();

            // 2. Draw Progress Arc
            ctx.beginPath();
            ctx.strokeStyle = root.color;
            ctx.lineWidth = 4;
            ctx.lineCap = "round";
            // Start at top (-PI/2), draw based on value
            var startAngle = -Math.PI / 2;
            var endAngle = startAngle + (root.value * 2 * Math.PI);
            ctx.arc(centerX, centerY, radius, startAngle, endAngle);
            ctx.stroke();
        }
    }

    // Update canvas whenever value changes
    onValueChanged: canvas.requestPaint()
}
