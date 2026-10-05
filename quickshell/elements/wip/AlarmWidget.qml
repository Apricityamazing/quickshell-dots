import Quickshell
import Quickshell.Wayland
import QtQuick

Scope {
    id: root
    property bool widgetOpen: Visibility.alarmWidgetVisible

    IpcHandler {
        target: "alarm"
        function toggle(): void {
            Visibility.alarmWidgetVisible = !Visibility.appLauncherVisible;
        }
        function show(): void {
            Visibility.alarmWidgetVisible = true;
        }
        function hide(): void {
            Visibility.alarmWidgetVisible = false;
        }
    }

    PanelWindow { // qmllint disable uncreatable-type
        visible: root.widgetOpen
        color: "transparent"
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        Component.onCompleted: {
            if (this.WlrLayershell != null) {
                this.WlrLayershell.layer = WlrLayer.Bottom;
            }
        }

        Rectangle {
            id: window
            width: parent.width * .55
            height: parent.height * .6
            anchors.centerIn: parent
            color: root.colBg
            radius: root.radius
        }
    }
}
