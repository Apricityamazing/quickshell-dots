pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

RowLayout {
    id: root
    spacing: 4

    required property var shellWindow
    property bool trayVisible: SystemTray.items.values.length > 0

    Repeater {
        model: SystemTray.items
        delegate: IconImage {
            id: trayItem
            required property SystemTrayItem modelData
            source: modelData.icon
            implicitSize: 16

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: trayItem.modelData.hasMenu ? Qt.PointingHandCursor : Qt.ArrowCursor

                onClicked: mouse => {
                    if (mouse.button === Qt.RightButton && trayItem.modelData.hasMenu) {
                        console.log("clicked");
                        menuAnchor.open();
                    } else if (mouse.button == Qt.LeftButton) {
                        console.log("clicked");
                        trayItem.modelData.activate();
                    }
                }
            }
            QsMenuAnchor {
                id: menuAnchor
                anchor.window: root.shellWindow
                Component.onCompleted: menu = trayItem.modelData.menu // qmllint disable unresolved-type
            }
        }
    }
}
