import Quickshell.Services.Pipewire
import QtQuick

Text {
    id: root

    // Overwrite the default sink
    property PwNode sink: PipeWireService.sink
    // Add new node
    // property PwNode myNode: Pipewire.nodes.values.find(n => n.name === "alsa_output.pci-0000_00_1f.3.analog-stereo")
    // You can find node names using 'pw-cli ls Node'

    text: internal.isMuted ? "󰝟" : (internal.volume == 0 ? "󰸈" : (internal.volume <= 20 ? "󰕿 " + internal.volume + "%" : (50 >= internal.volume ? "󰖀 " + internal.volume + "%" : "󰕾 " + internal.volume + "%")))

    // These can be overwritten when using them in your config like normal (ex. color: root.myColor)
    color: internal.defaultFontColor
    font.family: internal.defaultFontFamily
    font.pixelSize: internal.defaultFontSize

    PwObjectTracker {
        // Add sink after root.sink
        objects: {
            root.sink;
            // root.mySink;
        }
    }

    QtObject {
        id: internal
        property bool isMuted: root.sink.audio.muted
        property var volume: Math.round(root.sink.audio.volume * 100)
        property color defaultFontColor: "black"
        property var defaultFontFamily: "Helvetica"
        property int defaultFontSize: 13
    }
}
