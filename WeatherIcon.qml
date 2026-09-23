import QtQuick
import qs.Commons as Commons

Item {
  id: root

  property string iconName: "rainy"
  property color strokeColor: "#ffffff"
  property color accentColor: "#2dd4bf"

  implicitWidth: 80
  implicitHeight: 80

  Canvas {
    id: canvas
    anchors.fill: parent
    antialiasing: true

    onPaint: {
      var ctx = canvas.getContext("2d")
      ctx.reset()

      var w = width
      var h = height

      if (root.iconName === "rainy" || root.iconName === "thunderstorm") {
        // 1. Draw Cloud Outline
        ctx.strokeStyle = root.strokeColor
        ctx.lineWidth = 3.5
        ctx.lineCap = "round"
        ctx.lineJoin = "round"
        ctx.beginPath()

        // Cloud base line: x from 16 to 64, y at 38
        var cy = 36
        ctx.moveTo(22, cy)

        // Left arc
        ctx.arc(22, cy - 8, 8, Math.PI * 0.5, Math.PI * 1.4, false)
        // Top left puff
        ctx.arc(32, cy - 16, 12, Math.PI * 1.1, Math.PI * 1.85, false)
        // Top right puff
        ctx.arc(50, cy - 12, 10, Math.PI * 1.4, Math.PI * 0.2, false)
        // Right arc
        ctx.arc(58, cy - 6, 7, Math.PI * 1.8, Math.PI * 0.5, false)

        ctx.closePath()
        ctx.stroke()

        // 2. Draw 3 Diagonal Rain Drops
        ctx.strokeStyle = root.accentColor
        ctx.lineWidth = 3.0
        ctx.lineCap = "round"

        var dropY1 = cy + 10
        var dropY2 = cy + 22
        var dropDx = -4

        // Drop 1
        ctx.beginPath()
        ctx.moveTo(26, dropY1)
        ctx.lineTo(26 + dropDx, dropY2)
        ctx.stroke()

        // Drop 2
        ctx.beginPath()
        ctx.moveTo(40, dropY1)
        ctx.lineTo(40 + dropDx, dropY2)
        ctx.stroke()

        // Drop 3
        ctx.beginPath()
        ctx.moveTo(54, dropY1)
        ctx.lineTo(54 + dropDx, dropY2)
        ctx.stroke()
      } else if (root.iconName === "sunny" || root.iconName === "clear_day") {
        // Draw Sun Outline with Rays
        ctx.strokeStyle = root.strokeColor
        ctx.lineWidth = 3.5
        ctx.beginPath()
        ctx.arc(w / 2, h / 2, 16, 0, Math.PI * 2, false)
        ctx.stroke()

        ctx.lineWidth = 3.0
        ctx.lineCap = "round"
        var cx = w / 2
        var cy = h / 2
        var r1 = 22
        var r2 = 28
        for (var i = 0; i < 8; i++) {
          var angle = i * (Math.PI / 4)
          ctx.beginPath()
          ctx.moveTo(cx + Math.cos(angle) * r1, cy + Math.sin(angle) * r1)
          ctx.lineTo(cx + Math.cos(angle) * r2, cy + Math.sin(angle) * r2)
          ctx.stroke()
        }
      } else {
        // Cloud Default Outline
        ctx.strokeStyle = root.strokeColor
        ctx.lineWidth = 3.5
        ctx.lineCap = "round"
        ctx.lineJoin = "round"
        ctx.beginPath()

        var cy2 = h / 2 + 6
        ctx.moveTo(22, cy2)
        ctx.arc(22, cy2 - 8, 8, Math.PI * 0.5, Math.PI * 1.4, false)
        ctx.arc(32, cy2 - 16, 12, Math.PI * 1.1, Math.PI * 1.85, false)
        ctx.arc(50, cy2 - 12, 10, Math.PI * 1.4, Math.PI * 0.2, false)
        ctx.arc(58, cy2 - 6, 7, Math.PI * 1.8, Math.PI * 0.5, false)
        ctx.closePath()
        ctx.stroke()
      }
    }
  }

  onIconNameChanged: canvas.requestPaint()
  onStrokeColorChanged: canvas.requestPaint()
  onAccentColorChanged: canvas.requestPaint()
}
