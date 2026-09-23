import QtQuick
import qs.Commons as Commons

Item {
  id: root

  property real temperature: 27.0
  property real minTemp: -10.0
  property real maxTemp: 45.0
  property color mercuryColor: "#2dd4bf"
  property color borderColor: "#ffffff"

  readonly property real normalizedTemp: Math.max(0.0, Math.min(1.0, (temperature - minTemp) / (maxTemp - minTemp)))

  implicitWidth: 36
  implicitHeight: 110

  Canvas {
    id: canvas
    anchors.fill: parent
    antialiasing: true

    onPaint: {
      var ctx = canvas.getContext("2d")
      ctx.reset()

      var cx = 16
      var tubeWidth = 8
      var bulbRadius = 10
      var topY = 10
      var bottomY = height - 20
      var tubeLeft = cx - tubeWidth / 2
      var tubeRight = cx + tubeWidth / 2

      // 1. Draw Inner Mercury Fill
      var maxMercuryY = topY + 4
      var minMercuryY = bottomY - 2
      var mercuryHeight = (minMercuryY - maxMercuryY) * root.normalizedTemp
      var currentMercuryY = minMercuryY - mercuryHeight

      ctx.fillStyle = root.mercuryColor
      ctx.beginPath()

      // Bulb fill
      ctx.arc(cx, bottomY, bulbRadius - 2.5, 0, Math.PI * 2, false)
      ctx.fill()

      // Column fill
      if (mercuryHeight > 0) {
        ctx.beginPath()
        ctx.rect(tubeLeft + 2.5, currentMercuryY, tubeWidth - 5, minMercuryY - currentMercuryY + 2)
        ctx.fill()
      }

      // 2. Draw Outer Glass Outline
      ctx.strokeStyle = root.borderColor
      ctx.lineWidth = 2.2
      ctx.lineCap = "round"
      ctx.lineJoin = "round"
      ctx.beginPath()

      // Rounded top of tube
      ctx.arc(cx, topY, tubeWidth / 2, Math.PI, 0, false)

      // Right side of tube going down to bulb
      // Find intersection with bulb:
      // Tube extends to bottomY - sqrt(bulbRadius^2 - (tubeWidth/2)^2)
      var bulbIntersectY = bottomY - Math.sqrt(bulbRadius * bulbRadius - (tubeWidth / 2) * (tubeWidth / 2))
      var angleRight = Math.atan2(bulbIntersectY - bottomY, tubeRight - cx)
      var angleLeft = Math.atan2(bulbIntersectY - bottomY, tubeLeft - cx)

      ctx.lineTo(tubeRight, bulbIntersectY)

      // Outer bulb arc
      ctx.arc(cx, bottomY, bulbRadius, angleRight, angleLeft, false)

      // Left side of tube going up
      ctx.lineTo(tubeLeft, topY)
      ctx.stroke()

      // 3. Draw Tick Marks on Right Side
      ctx.strokeStyle = root.borderColor
      ctx.lineWidth = 1.8
      var numTicks = 4
      var tickLength = 5
      var tickStartX = tubeRight + 4

      for (var i = 0; i < numTicks; i++) {
        var ty = topY + 4 + i * ((bottomY - topY - 16) / (numTicks - 1))
        ctx.beginPath()
        ctx.moveTo(tickStartX, ty)
        ctx.lineTo(tickStartX + tickLength, ty)
        ctx.stroke()
      }
    }
  }

  onTemperatureChanged: canvas.requestPaint()
  onMercuryColorChanged: canvas.requestPaint()
  onBorderColorChanged: canvas.requestPaint()
}
