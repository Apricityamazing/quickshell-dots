pragma Singleton
import Quickshell
import Quickshell.Networking
//import Quickshell.Io
import QtQuick

Singleton {
    id: root
    readonly property var activeDevice: {
        let count = Networking.devices.values.length;
        for (let i = 0; i < count; i++) {
            let device = Networking.devices.values[i];
            if (device && device.state === ConnectionState.Connected) {
                return device;
            }
        }
        return null;
    }
    readonly property string deviceLabel: activeDevice.name
    readonly property bool isConnected: activeDevice.connected
    readonly property var wifiDevice: activeDevice.type === DeviceType.Wifi ? activeDevice : null
    readonly property bool isWifiDevice: wifiDevice !== null
    readonly property var wiredDevice: activeDevice.type === DeviceType.Wired ? activeDevice : null
    readonly property bool isWiredDevice: wiredDevice !== null
    readonly property var availableWifiNetworks: wifiDevice?.networks.values
    readonly property var connectedWifiNetwork: {
        for (let i = 0; i < availableWifiNetworks.length; i++) {
            let network = availableWifiNetworks[i];
            if (network) {
                return network;
            }
        }
        return null;
    }
    readonly property string connectedWifiNetworkName: connectedWifiNetwork === null ? "No Wifi Network Connected" : connectedWifiNetwork.name
    function getWifiStrength(device) {
        let wifiStrength = device.signalStrength;
        return wifiStrength < 0.2 ? "󰤯" : wifiStrength <= 0.4 ? "󰤟" : wifiStrength <= 0.6 ? "󰤢" : wifiStrength <= 0.8 ? "󰤥" : "󰤨";
    }
    Component.onCompleted: {
        if (isWifiDevice) {
            wifiDevice.scannerEnabled = true;
        }
        Networking.wifiEnabled = true;
    }
}
