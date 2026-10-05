pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick

Rectangle {
    id: root
    color: "transparent"
    implicitHeight: 16
    implicitWidth: 12

    PersistentProperties {
        id: persist
        reloadableId: "persistedStates"

        property bool inhibitorEnabled: false
    }
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
        text: persist.inhibitorEnabled ? "󰈈" : "󰈉"
        color: root.textColor
        MouseArea {
            anchors.fill: parent
            cursorShape: Qt.PointingHandCursor
            onClicked: persist.inhibitorEnabled = !persist.inhibitorEnabled
        }
    }

    IdleInhibitor {
        id: inhibitor
        window: root.importantWindow
        enabled: persist.inhibitorEnabled
    }

    QtObject {
        id: internal
        property color defaultColor: "white"
    }
}
