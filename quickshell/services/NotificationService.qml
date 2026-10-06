pragma Singleton
import Quickshell
import Quickshell.Services.Notifications
import QtQuick

Singleton {
    id: root
    readonly property ListModel notificationHistory: historyModel

    ListModel {
        id: historyModel
    }
    PersistentProperties {
        id: persist
        reloadableId: "notificationHistory"
        // Plain data only - engine properties of object type come back null.
        property string historyJson: "[]"

        Component.onCompleted: root.rehydrate()
    }

    function rehydrate() {
        historyModel.clear();
        try {
            const parsed = JSON.parse(persist.historyJson);
            if (Array.isArray(parsed))
                for (const entry of parsed)
                    historyModel.append(entry);
        } catch (e) {
            console.warn("NotificationService: could not restore history:", e);
        }
    }

    function serialize() {
        const out = [];
        for (let i = 0; i < historyModel.count; i++)
            out.push(historyModel.get(i));
        persist.historyJson = JSON.stringify(out);
    }

    property NotificationServer server: NotificationServer {
        id: server
        actionsSupported: true
        bodySupported: true
        imageSupported: true
        onNotification: n => {
            historyModel.insert(0, {
                summary: n.summary,
                body: n.body,
                appName: n.appName,
                urgency: n.urgency,
                time: Qt.formatDateTime(new Date(), "HH:mm")
            });
            n.tracked = true;
        }
    }

    Connections {
        target: historyModel
        function onCountChanged() {
            root.serialize();
        }
    }
}
