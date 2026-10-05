pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    readonly property int currentBrightness: persist.currentBrightness
    readonly property int maxBrightness: persist.maxBrightness
    readonly property string brightnessIcon: persist.brightnessIcon

		QtObject {
			id: internal
			function runIf(alreadyRan: bool): bool {
				if (!alreadyRan) {
					return true;
				} else {
					return false;
				}
			}
		}
    PersistentProperties {
        id: persist
        reloadableId: "persistedStates"

        property int currentBrightness: 0
        property int maxBrightness: 0
        property string brightnessIcon: currentBrightness <= 20 ? "" : currentBrightness <= 30 ? "" : currentBrightness <= 40 ? "" : currentBrightness <= 50 ? "" : currentBrightness <= 60 ? "" : currentBrightness <= 70 ? "" : currentBrightness <= 80 ? "" : currentBrightness <= 90 ? "" : ""
        property bool ran: false
    }

    IpcHandler {
        target: "brightness"
        function increaseBrightness(amount: int): void {
            var newBrightness = persist.currentBrightness + amount;
            if (newBrightness > 100) {
                persist.currentBrightness = 100;
            } else {
                persist.currentBrightness = newBrightness;
            }
        }
        function decreaseBrightness(amount: int): void {
            var newBrightness = persist.currentBrightness - amount;
            if (newBrightness < 0) {
                persist.currentBrightness = 0;
            } else {
                persist.currentBrightness = newBrightness;
            }
        }
    }

    Process {
        id: initialBrightness
        command: ["sh", "-c", "ddcutil getvcp 10 --brief"]
        stdout: SplitParser {
            onRead: data => {
                if (!data) {
                    persist.currentBrightness = -1;
                    persist.maxBrightness = -1;
                    console.log("Failed to get initial brightness");
                    return;
                }
                var parts = data.trim().split(/\s+/);
                var initialBrightness = parseInt(parts[3]);
                var max = parseInt(parts[4]);
                persist.currentBrightness = initialBrightness;
                persist.maxBrightness = max;
            }
        }
				// Checks if process already ran, making it so no extra function calls are made ever
        Component.onCompleted: running = internal.runIf(persist.ran)
    }
}
