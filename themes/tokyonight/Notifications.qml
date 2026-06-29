pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Io
import Quickshell.Services.Notifications
import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    property bool centerOpen: false
    // qmlformat off
    ListModel { id: history }
    // qmlformat on

    IpcHandler {
        target: "notifications"
        function toggle(): void {
            root.centerOpen = !root.centerOpen;
        }
        function show(): void {
            root.centerOpen = true;
        }
        function hide(): void {
            root.centerOpen = false;
        }
    }

    QtObject {
        id: internal
        property color defaultUrgentBorder: "red"
        property color defaultBorder: "black"
        property color defaultBackgroundColor: "white"
        property color defaultForegroundColor: "black"
        property color defaultFontColor: "black"
        property int defaultAnimationDuration: 300
        property int defaultNotificationTimeout: 5000
        property int fontSize: 13
        property var fontFamily: "Helvetica"
    }
    property color colUrgentBorder: internal.defaultUrgentBorder
    property color colBorder: internal.defaultBorder
    property color colBg: internal.defaultBackgroundColor
    property color colFg: internal.defaultForegroundColor
    property color fontColor: internal.defaultFontColor
    property int fontSize: internal.fontSize
    property var fontFamily: internal.fontFamily
    property int notificationTimeout: internal.defaultNotificationTimeout
    property int animationDuration: internal.defaultAnimationDuration

    property color summaryFontColor: root.fontColor
    property font summaryFont: Qt.font({
        family: root.fontFamily,
        pixelSize: root.fontSize,
        bold: true
    })
    property color bodyFontColor: root.fontColor
    property font bodyFont: Qt.font({
        family: root.fontFamily,
        pixelSize: root.fontSize - 1,
        bold: true
    })
    property color centerTitleFontColor: root.fontColor
    property font centerTitleFont: Qt.font({
        family: root.fontFamily,
        pixelSize: root.fontSize
    })
    property color centerTimeFontColor: root.fontColor
    property font centerTimeFont: Qt.font({
        family: root.fontFamily,
        pixelSize: root.fontSize - 3
    })
    property color centerExitFontColor: root.fontColor
    property font centerExitFont: Qt.font({
        family: "JetBrainsMono Nerd Font",
        pixelSize: root.fontSize - 1
    })
    property color centerAppNameFontColor: root.fontColor
    property font centerAppNameFont: Qt.font({
        family: root.fontFamily,
        pixelSize: root.fontSize - 4
    })

    NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true
        onNotification: n => {
            history.insert(0, {
                summary: n.summary,
                body: n.body,
                appName: n.appName,
                urgency: n.urgency,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            });
            n.tracked = true;
        }
    }

    PanelWindow { // qmllint disable uncreatable-type
        visible: !root.centerOpen
        anchors {
            top: true
            right: true
        }
        margins { // qmllint disable unqualified unresolved-type
            top: 12
            right: 12
        }

        implicitWidth: 380
        implicitHeight: Math.max(1, column.implicitHeight)
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        ColumnLayout {
            id: column
            width: parent.width
            spacing: 10

            Repeater {
                model: server.trackedNotifications
                delegate: Rectangle {
                    id: card
                    required property var modelData

                    ParallelAnimation {
                        id: closeNotification
                        running: false
                        onStopped: card.modelData.dismiss()
                        NumberAnimation {
                            id: exitFadeAnimation
                            target: card
                            property: "opacity"
                            to: 0
                            duration: root.animationDuration
                            easing.type: Easing.OutCirc
                        }
                    }

                    function dismissWithAnimation() {
                        closeNotification.running = true;
                    }

                    Timer {
                        running: card.modelData.urgency !== NotificationUrgency.Critical
                        interval: root.notificationTimeout
                        onTriggered: card.dismissWithAnimation()
                    }

                    Layout.fillWidth: true
                    Layout.preferredHeight: layout.implicitHeight + 20
                    radius: 8
                    color: root.colBg
                    border.width: 2
                    border.color: modelData.urgency === NotificationUrgency.Critical ? root.colUrgentBorder : root.colBorder

                    RowLayout {
                        id: layout
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        Image {
                            Layout.preferredHeight: 36
                            Layout.preferredWidth: 36
                            Layout.alignment: Qt.AlignTop
                            fillMode: Image.PreserveAspectFit
                            visible: source.toString() !== ""
                            source: card.modelData.image || card.modelData.appIcon || ""
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Text {
                                Layout.fillWidth: true
                                text: card.modelData.summary
                                color: root.summaryFontColor
                                font: root.summaryFont
                                elide: Text.ElideRight
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: text !== ""
                                text: card.modelData.body
                                color: root.bodyFontColor
                                font: root.bodyFont
                                wrapMode: Text.WordWrap
                            }
                        }
                    }
                    MouseArea {
                        anchors.fill: parent
                        onClicked: card.dismissWithAnimation()
                    }
                }
            }
        }
    }
    // Notification Center
    PanelWindow { // qmllint disable uncreatable-type
        visible: root.centerOpen
        anchors {
            top: true
            right: true
        }
        margins { // qmllint disable unqualified unresolved-type
            top: 12
            right: 12
        }

        implicitWidth: 380
        implicitHeight: centerCol.implicitHeight + 24
        color: "transparent"

        exclusionMode: ExclusionMode.Ignore

        Rectangle {
            anchors.fill: parent
            radius: 10
            color: root.colBg
            border.width: 2
            border.color: root.colBorder

            ColumnLayout {
                id: centerCol
                anchors.fill: parent
                anchors.margins: 12
                spacing: 10

                RowLayout {
                    Layout.fillWidth: true

                    Text {
                        Layout.fillWidth: true
                        text: "Notification"
                        color: root.summaryFontColor
                        font: root.summaryFont
                    }

                    Text {
                        text: "Clear all"
                        visible: history.count > 0
                        color: root.bodyFontColor
                        font: root.bodyFont
                        MouseArea {
                            anchors.fill: parent
                            onClicked: history.clear()
                        }
                    }
                }

                Text {
                    visible: history.count === 0
                    text: "No notifications"
                    color: root.centerTitleFontColor
                    font: root.centerTitleFont
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                }

                ListView {
                    Layout.fillWidth: true
                    Layout.preferredHeight: Math.min(contentHeight, 500)
                    clip: true
                    spacing: 8
                    model: history

                    delegate: Rectangle {
                        id: notifCard
                        required property int index
                        required property var model

                        width: ListView.view.width
                        implicitHeight: cardCol.implicitHeight + 16
                        radius: 8
                        color: root.colBg
                        border.width: 1
                        border.color: model.urgency === NotificationUrgency.Critical ? root.colUrgentBorder : root.colBorder

                        ColumnLayout {
                            id: cardCol
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 2

                            RowLayout {
                                Layout.fillWidth: true
                                spacing: 6
                                Text {
                                    Layout.fillWidth: true
                                    text: notifCard.model.summary
                                    color: root.colFg
                                    font: root.summaryFont
                                    elide: Text.ElideRight
                                }
                                Text {
                                    text: notifCard.model.time
                                    color: root.centerTimeFontColor
                                    font: root.centerTimeFont
                                }
                                Text {
                                    text: "󰅖"
                                    color: root.centerExitFontColor
                                    font: root.centerExitFont
                                    MouseArea {
                                        anchors.fill: parent
                                        onClicked: history.remove(notifCard.index)
                                    }
                                }
                            }

                            Text {
                                Layout.fillWidth: true
                                visible: notifCard.model.body !== ""
                                text: notifCard.model.body
                                color: root.bodyFontColor
                                font: root.bodyFont
                                wrapMode: Text.WordWrap
                            }
                            Text {
                                visible: notifCard.model.appName !== ""
                                text: notifCard.model.appName
                                color: root.centerAppNameFontColor
                                font: root.centerAppNameFont
                            }
                        }
                    }
                }
            }
        }
    }
}
