pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    readonly property int cpuUsage: persist.cpuUsage

    // CPU widget doesn't spaz out when quickshell is reloaded
    PersistentProperties {
        id: persist
        property int cpuUsage: 0
        property var lastCpuTotal: 0
        property var lastCpuIdle: 0
    }

    Process {
        id: cpuProc
        command: ["sh", "-c", "head -1 /proc/stat"]
        stdout: SplitParser {
            onRead: data => {
                if (!data)
                    return;
                var p = data.trim().split(/\s+/);
                var idle = parseInt(p[4]) + parseInt(p[5]);
                var total = p.slice(1, 8).reduce((a, b) => a + parseInt(b), 0);
                if (persist.lastCpuTotal > 0) {
                    persist.cpuUsage = Math.round(100 * (1 - (idle - persist.lastCpuIdle) / (total - persist.lastCpuTotal)));
                }
                persist.lastCpuTotal = total;
                persist.lastCpuIdle = idle;
            }
        }
        Component.onCompleted: running = true
    }
    Timer {
        interval: 2000
        running: true
        repeat: true
        onTriggered: cpuProc.running = true
    }
}
