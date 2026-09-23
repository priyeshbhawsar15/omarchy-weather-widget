import QtQuick
import QtQuick.Layouts
import qs.Commons as Commons

Rectangle {
  id: root

  property var weatherData: null

  readonly property color themeAccent: (Commons.Color.bar && Commons.Color.bar.active)
    ? Commons.Color.bar.active : (Commons.Color.accent ? Commons.Color.accent : "#2dd4bf")

  readonly property int currentTemp: weatherData && weatherData.currentTemp !== undefined
    ? Number(weatherData.currentTemp) : 27
  readonly property string iconName: weatherData && weatherData.icon
    ? String(weatherData.icon) : "rainy"
  readonly property string subtitleText: weatherData && weatherData.subtitle
    ? String(weatherData.subtitle) : "Kyoto · Light rain shower · 80%"
  readonly property var forecastList: weatherData && weatherData.forecast
    ? weatherData.forecast : [
        {"time": "12h", "temp": 29, "icon": "rainy"},
        {"time": "15h", "temp": 29, "icon": "rainy"},
        {"time": "18h", "temp": 26, "icon": "rainy"}
      ]

  implicitWidth: 390
  implicitHeight: 165
  radius: Commons.Style.space(16)
  color: Qt.rgba(Commons.Color.background.r, Commons.Color.background.g, Commons.Color.background.b, 0.85)
  border.width: 1
  border.color: Qt.rgba(root.themeAccent.r, root.themeAccent.g, root.themeAccent.b, 0.30)
  clip: true

  RowLayout {
    anchors.fill: parent
    anchors.margins: Commons.Style.space(16)
    spacing: Commons.Style.space(14)

    // 1. Large Weather Icon (Left)
    WeatherIcon {
      id: mainIcon
      iconName: root.iconName
      strokeColor: Commons.Color.foreground
      accentColor: root.themeAccent
      implicitWidth: 76
      implicitHeight: 76
      Layout.alignment: Qt.AlignVCenter
    }

    // 2. Thermometer Gauge (Middle)
    ThermometerGauge {
      id: thermometer
      temperature: root.currentTemp
      mercuryColor: root.themeAccent
      borderColor: Commons.Color.foreground
      implicitWidth: 36
      implicitHeight: 110
      Layout.alignment: Qt.AlignVCenter
    }

    // 3. Right Details Column
    ColumnLayout {
      Layout.fillWidth: true
      Layout.fillHeight: true
      spacing: Commons.Style.space(4)

      // Large Temperature Readout
      Text {
        text: root.currentTemp + "°"
        color: Commons.Color.foreground
        font.family: Commons.Style.font.family
        font.pixelSize: 34
        font.weight: Font.Bold
      }

      // Location & Condition Subtitle
      Text {
        text: root.subtitleText
        color: Commons.Color.muted
        font.family: Commons.Style.font.family
        font.pixelSize: Commons.Style.font.caption
        Layout.fillWidth: true
        elide: Text.ElideRight
      }

      Item { Layout.preferredHeight: 6 }

      // 3-Column Hourly Forecast Row
      RowLayout {
        Layout.fillWidth: true
        spacing: Commons.Style.space(20)

        Repeater {
          model: root.forecastList

          ColumnLayout {
            required property var modelData

            Layout.alignment: Qt.AlignHCenter
            spacing: 2

            // Time e.g. 12h
            Text {
              text: modelData.time ? String(modelData.time) : ""
              color: Commons.Color.muted
              font.family: Commons.Style.font.family
              font.pixelSize: Commons.Style.font.caption - 1
              Layout.alignment: Qt.AlignHCenter
            }

            // Small Weather Icon
            Text {
              text: modelData.icon === "sunny" || modelData.icon === "clear_day" ? "󰖙" : (modelData.icon === "snowy" ? "󰼶" : "󰖗")
              color: root.themeAccent
              font.family: Commons.Style.font.family
              font.pixelSize: 16
              Layout.alignment: Qt.AlignHCenter
            }

            // Forecast Temp e.g. 29°
            Text {
              text: (modelData.temp !== undefined ? modelData.temp : "--") + "°"
              color: Commons.Color.foreground
              font.family: Commons.Style.font.family
              font.pixelSize: Commons.Style.font.caption
              font.weight: Font.DemiBold
              Layout.alignment: Qt.AlignHCenter
            }
          }
        }
      }
    }
  }
}
