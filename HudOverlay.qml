import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons as Commons

PanelWindow {
  id: hudWindow

  property var pluginService: null
  property string targetScreenName: "DP-4"

  readonly property color themeAccent: (Commons.Color.bar && Commons.Color.bar.active)
    ? Commons.Color.bar.active : Commons.Color.accent

  readonly property bool isPinned: pluginService ? pluginService.isPinned : false
  readonly property bool autohideEnabled: pluginService ? pluginService.autohideEnabled : false
  property bool isHovered: false
  readonly property bool isRevealed: !autohideEnabled || isHovered

  readonly property int cardWidth: 390
  readonly property int edgeRevealSize: 14
  readonly property int horizontalInset: Commons.Style.space(16)

  screen: {
    const list = Quickshell.screens || []
    for (let i = 0; i < list.length; i++) {
      if (list[i] && list[i].name === targetScreenName) return list[i]
    }
    return list.length > 1 ? list[1] : (list.length > 0 ? list[0] : null)
  }

  anchors {
    top: true
    right: true
  }

  margins {
    top: Commons.Style.space(900)
    right: 0
  }

  implicitWidth: cardWidth + horizontalInset
  implicitHeight: card.implicitHeight
  color: "transparent"

  WlrLayershell.namespace: "omarchy-weather-widget"
  WlrLayershell.layer: isPinned ? WlrLayer.Overlay : WlrLayer.Bottom
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
  exclusionMode: ExclusionMode.Ignore

  mask: Region {
    x: hudWindow.isRevealed ? 0 : (hudWindow.width - hudWindow.edgeRevealSize)
    y: 0
    width: hudWindow.isRevealed ? hudWindow.width : hudWindow.edgeRevealSize
    height: hudWindow.height
  }

  Timer {
    id: autoHideTimer
    interval: 700
    onTriggered: {
      if (hudWindow.autohideEnabled && !cardHoverArea.containsMouse && !edgeHoverArea.containsMouse) {
        hudWindow.isHovered = false
      }
    }
  }

  function requestShow() {
    autoHideTimer.stop()
    hudWindow.isHovered = true
  }

  function requestHide() {
    if (hudWindow.autohideEnabled) {
      autoHideTimer.restart()
    }
  }

  // Right Edge Trigger Sensor (when collapsed)
  MouseArea {
    id: edgeHoverArea
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    width: hudWindow.edgeRevealSize
    hoverEnabled: true
    acceptedButtons: Qt.NoButton
    z: 100
    onEntered: hudWindow.requestShow()
    onExited: hudWindow.requestHide()
  }

  Item {
    id: cardWrapper
    width: hudWindow.cardWidth
    height: card.implicitHeight
    anchors.top: parent.top
    x: hudWindow.isRevealed ? 0 : (parent.width - hudWindow.edgeRevealSize)

    Behavior on x {
      NumberAnimation { duration: 320; easing.type: Easing.OutCubic }
    }

    MouseArea {
      id: cardHoverArea
      anchors.fill: parent
      hoverEnabled: true
      acceptedButtons: Qt.NoButton
      onEntered: hudWindow.requestShow()
      onExited: hudWindow.requestHide()
    }

    WeatherCard {
      id: card
      anchors.fill: parent
      pluginService: hudWindow.pluginService
      weatherData: hudWindow.pluginService ? hudWindow.pluginService.weatherData : null
    }
  }

  // Edge Grab Handle Pill (when collapsed in auto-hide mode)
  Rectangle {
    anchors.left: cardWrapper.left
    anchors.verticalCenter: cardWrapper.verticalCenter
    width: 6
    height: 80
    radius: 3
    color: hudWindow.themeAccent
    opacity: hudWindow.isRevealed ? 0 : 0.85
    z: 90

    Behavior on opacity {
      NumberAnimation { duration: 200 }
    }
  }
}
