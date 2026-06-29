pragma Singleton
import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root
    property int cpuUsage: 0

    QtObject {
        id: internal
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
                if (internal.lastCpuTotal > 0) {
                    root.cpuUsage = Math.round(100 * (1 - (idle - internal.lastCpuIdle) / (total - internal.lastCpuTotal)));
                }
                internal.lastCpuTotal = total;
                internal.lastCpuIdle = idle;
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
