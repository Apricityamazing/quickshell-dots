pragma Singleton
import QtQuick
import Quickshell
import Quickshell.Networking

Singleton {
    id: root

    // Current state (updated by update())
    property var deviceType: null
    property bool isConnected: false
    property bool isWifiDevice: false
    property bool isWiredDevice: false
    // Display-ready values
    property string iconText: ""
    property string statusText: ""

    signal connectionChanged(var type)

    // Made a function so no errors are emitted because of early bindings
    function activeDevice() {
        const devices = Networking.devices.values;
        for (let i = 0; i < devices.length; i++) {
            const device = Networking.devices.values[i];
            if (device && device.state === ConnectionState.Connected)
                return device;
        }
        return null;
    }

    function connectedWifiNetwork() {
        const device = root.activeDevice();
        if (!device || device.type !== DeviceType.Wifi)
            return null;

        // Makes it so wired connections don't try and set values for wifi values
        const networks = device.networks.values;
        for (let i = 0; i < networks.length; i++) {
            const network = networks[i];
            if (network.connected)
                return network;
        }
        return null;
    }

    function wifiStrengthSymbol(network) {
        if (!network)
            return "󰤮";
        // qmlformat off
        const strength = network.signalStrength;
        // 0.0 weak - 1.0 strong
				return strength < 0.2 ? "󰤯"
				: strength <= 0.4 ? "󰤟"
				: strength <= 0.6 ? "󰤢"
				: strength <= 0.8 ? "󰤥"
				: "󰤨";
				// qmlformat on

    }

    function update() {
        const device = root.activeDevice();
        const type = device === null ? null : device.type;
        const network = root.connectedWifiNetwork();
        root.deviceType = type;
        root.isConnected = device !== null;
        root.isWifiDevice = type === DeviceType.Wifi;
        root.isWiredDevice = type === DeviceType.Wired;
        if (type === DeviceType.Wifi) {
            root.iconText = network ? root.wifiStrengthSymbol(network) : "󰤮";
            root.statusText = network ? network.name : "No Wifi Network Connected";
        } else if (type === DeviceType.Wired) {
            root.iconText = "";
            root.statusText = "";
        } else {
            root.iconText = "󰤮";
            root.statusText = "";
        }
        root.connectionChanged(type); // The signal
    }

    function refreshHooks() {
        for (let i = 0; i < internal.watched.length; i++) {
            let device = internal.watched[i];
            device.stateChanged.disconnect(root.update);
            device.connectedChanged.disconnect(root.update);
        }
        internal.watched = [];
        const devices = Networking.devices.values;
        for (let i = 0; i < devices.length; i++) {
            let device = devices[i];
            if (!device)
                continue;

            internal.watched.push(device);
            device.stateChanged.connect(root.update);
            device.connectedChanged.connect(root.update);
        }
    }

    Component.onCompleted: {
        Networking.wifiEnabled = true;
        refreshHooks();
        update();
    }

    // Change detection
    QtObject {
        id: internal

        property var watched: []
    }

    Connections {
        function onObjectInsertedPost() {
            root.refreshHooks();
            root.update();
        }

        function onObjectRemovedPost() {
            root.refreshHooks();
            root.update();
        }

        target: Networking.devices
    }
}
