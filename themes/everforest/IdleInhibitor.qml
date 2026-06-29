pragma ComponentBehavior: Bound
import Quickshell.Wayland
import QtQuick

Rectangle {
    id: root
    color: "transparent"
    implicitHeight: 16
    implicitWidth: 12

    property var importantWindow
    property font font: Qt.font({
        family: "Helvetica",
        pixelSize: 13
    })
    property color textColor: internal.defaultColor

    Text {
        anchors.centerIn: parent
        leftPadding: 2
        rightPadding: 2
        text: inhibitor.enabled ? "󰈈" : "󰈉"
        color: root.textColor
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: inhibitor.enabled = !inhibitor.enabled
        }
    }
    IdleInhibitor {
        id: inhibitor
        window: root.importantWindow
        enabled: false
    }

    QtObject {
        id: internal
        property color defaultColor: "white"
    }
}
