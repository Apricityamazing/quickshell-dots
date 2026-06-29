pragma ComponentBehavior: Bound
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    // Can be overwritten
    property color activeWorkspaceColor: internal.defaultActiveColor
    property color inactiveWorkspaceColor: internal.defaultInactiveColor
    property color emptyInactiveWorkspaceColor: internal.defaultEmptyInactiveColor
    property font font: Qt.font({
        family: "Helvetica",
        pixelSize: 13,
        bold: false,
        italic: false,
        weight: Font.Normal
    })

    QtObject {
        id: internal
        property color defaultActiveColor: "white"
        property color defaultInactiveColor: "grey"
        property color defaultEmptyInactiveColor: "black"
    }

    RowLayout {
        id: layout
        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        spacing: 6

        Repeater {
            model: 9
            Text {
                required property int index
                property var ws: Hyprland.workspaces.values.find(w => w.id === index + 1)
                property bool isActive: Hyprland.focusedWorkspace?.id === (index + 1)
                text: index + 1
                color: isActive ? root.activeWorkspaceColor : (ws ? root.inactiveWorkspaceColor : root.emptyInactiveWorkspaceColor)
                font: root.font

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: Hyprland.dispatch("hl.dsp.focus({ workspace = " + (parent.index + 1) + " })")
                }
            }
        }
    }
}
