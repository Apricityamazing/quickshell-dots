import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    QtObject {
        id: internal
        property color defaultColor: "white"
    }
    property font font: Qt.font({
        family: "Helvetica",
        pixelSize: 13,
        bold: false,
        italic: false,
        weight: Font.Normal
    })
    property color color: internal.defaultColor
    Text {
        visible: NetworkService.isWifiDevice
        text: NetworkService.isConnected === false ? "󰤮" : NetworkService.getWifiStrength(NetworkService.wifiDevice)
        color: root.color
        font: root.font
    }
    Text {
        visible: NetworkService.isWifiDevice
        text: NetworkService.connectedWifiNetworkName
        color: root.color
        font: root.font
    }

    Text {
        visible: NetworkService.isWiredDevice
        text: NetworkService.isConnected === false ? "Not Connected" : ""
        color: root.color
        font: root.font
    }
}
