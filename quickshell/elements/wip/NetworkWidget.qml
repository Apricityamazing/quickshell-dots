pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Networking
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    property bool widgetOpen: false
    property font font: Qt.font({
        family: "Helvetica",
        pixelSize: 13
    })
    IpcHandler {
        target: "network"
        function toggle(): void {
            root.widgetOpen = !root.widgetOpen;
        }
        function show(): void {
            root.widgetOpen = true;
        }
        function hide(): void {
            root.widgetOpen = false;
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
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        Rectangle {
            width: parent.width * .3
            height: parent.height * .8
            anchors.centerIn: parent
            color: "white"

            ListView {
                anchors.centerIn: parent
                width: parent.width - 10
                height: parent.height - 10
                spacing: 8

                model: NetworkService.availableWifiNetworks
                delegate: Rectangle {
                    id: networkBox
                    required property var modelData
                    required property int index
                    width: ListView.view.width
                    height: 30
                    border.width: 1
                    border.color: "black"
                    RowLayout {

                        Text {
                            text: networkBox.modelData.name
                            font: root.font
                        }

                        Text {
                            text: NetworkService.getWifiStrength(networkBox.modelData)
                            font: root.font
                        }
                    }
                }
            }
        }
    }
}
