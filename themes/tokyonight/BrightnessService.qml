pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    readonly property int currentBrightness: internal.currentBrightness
    readonly property int maxBrightness: internal.maxBrightness
    readonly property string brightnessIcon: internal.brightnessIcon
    QtObject {
        id: internal
        property int currentBrightness: 0
        property int maxBrightness: 0
        property string brightnessIcon: currentBrightness <= 20 ? "" : currentBrightness <= 30 ? "" : currentBrightness <= 40 ? "" : currentBrightness <= 50 ? "" : currentBrightness <= 60 ? "" : currentBrightness <= 70 ? "" : currentBrightness <= 80 ? "" : currentBrightness <= 90 ? "" : ""
    }

    IpcHandler {
        target: "brightness"
        function increaseBrightness(amount: int): void {
            var newBrightness = internal.currentBrightness + amount;
            if (newBrightness > 100) {
                internal.currentBrightness = 100;
            } else {
                internal.currentBrightness = newBrightness;
            }
        }
        function decreaseBrightness(amount: int): void {
            var newBrightness = internal.currentBrightness - amount;
            if (newBrightness < 0) {
                internal.currentBrightness = 0;
            } else {
                internal.currentBrightness = newBrightness;
            }
        }
    }

    Process {
        id: initialBrightness
        command: ["sh", "-c", "ddcutil getvcp 10 --brief"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) {
                    internal.currentBrightness = -1;
                    internal.maxBrightness = -1;
                    console.log("Failed to get initial brightness");
                    return;
                }
                var parts = data.trim().split(/\s+/);
                var initialBrightness = parseInt(parts[3]);
                var max = parseInt(parts[4]);
                internal.currentBrightness = initialBrightness;
                internal.maxBrightness = max;
            }
        }
        Component.onCompleted: running = true
    }
}
