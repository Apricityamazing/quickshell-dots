import QtQuick
import QtQuick.Layouts

Item {
    id: root
    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

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

    RowLayout {
        id: layout
        Text {
            visible: NetworkService.isWifiDevice
            text: NetworkService.isConnected === false ? "󰤮" : NetworkService.getWifiStrength(NetworkService.connectedWifiNetwork)
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
}
