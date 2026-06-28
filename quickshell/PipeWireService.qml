pragma Singleton
import Quickshell
import Quickshell.Services.Pipewire
import QtQuick

Singleton {
    // This sets the default sink, which can be overwritten or added to in PipeWireWidget.qml
    property PwNode sink: internal.defaultSink

    QtObject {
        id: internal
        property PwNode defaultSink: Pipewire.defaultAudioSink
    }
}
