import QtQuick

Text {
    id: root
    QtObject {
        id: internal
        property color defaultColor: "black"
    }
    property bool hasNotifications: NotificationService.notificationHistory.count > 0
    text: hasNotifications ? "󱅫" : "󰂚"
    font.pixelSize: 13
    font.family: "Helvetica"
    color: internal.defaultColor

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: Visibility.notificationWidgetVisible = !Visibility.notificationWidgetVisible
    }
}
