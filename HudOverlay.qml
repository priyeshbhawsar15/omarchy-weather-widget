import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.Commons as Commons

PanelWindow {
  id: hudWindow

  property var pluginService: null
  property string targetScreenName: "DP-4"

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
    top: Commons.Style.space(735)
    right: Commons.Style.space(16)
  }

  implicitWidth: 390
  implicitHeight: 165
  color: "transparent"

  WlrLayershell.namespace: "omarchy-weather-widget"
  WlrLayershell.layer: WlrLayer.Bottom
  WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
  exclusionMode: ExclusionMode.Ignore

  WeatherCard {
    id: card
    anchors.fill: parent
    weatherData: hudWindow.pluginService ? hudWindow.pluginService.weatherData : null
  }
}
