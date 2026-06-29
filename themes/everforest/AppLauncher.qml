//@ pragma IconTheme hicolor
pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import Quickshell.Widgets
import QtQuick
import QtQuick.Layouts

Scope {
    id: root
    property bool launcherOpen: false

    QtObject {
        id: internal
        property int defaultAmountOfColumns: 3
        property int highlightedIndex
        property var defaultTerminal: "kitty"
        property color colDefaultFont: "black"
        property color colDefaultBorder: "black"
        property int defaultBorderWidth: 1
        property color colDefaultHighlight: "#800000FF"
        property color colDefaultHighlightBorder: "blue"
        property color defaultColBg: "black"
        property color defaultColFg: "white"
        property int defaultRadius: 5
        function close() {
            root.launcherOpen = false;
            searchInput.clear();
        }
    }

    property int radius: internal.defaultRadius
    property color colBg: internal.defaultColBg
    property color colFg: internal.defaultColFg
    property int amountOfColumns: internal.defaultAmountOfColumns
    property var terminal: internal.defaultTerminal
    property color colEntryFont: internal.colDefaultFont
    property color colEntryBorder: internal.colDefaultBorder
    property int entryBorderWidth: root.borderWidth
    property color colSearchFont: internal.colDefaultFont
    property color colSearchBorder: internal.colDefaultBorder
    property int searchBorderWidth: root.borderWidth
    property int borderWidth: internal.defaultBorderWidth
    property color colHighlight: internal.colDefaultHighlight
    property color colHighlightBorder: internal.colDefaultHighlightBorder
    property font defaultFont: Qt.font({
        family: "Helvetica",
        pixelSize: 13
    })
    property font entryFont: Qt.font({
        family: root.defaultFont.family,
        pixelSize: root.defaultFont.pixelSize + 3
    })
    property font searchFont: root.defaultFont

    IpcHandler {
        target: "launcher"
        function toggle(): void {
            root.launcherOpen = !root.launcherOpen;
            searchInput.clear();
        }
        function show(): void {
            root.launcherOpen = true;
        }
        function hide(): void {
            root.launcherOpen = false;
            searchInput.clear();
        }
    }

    function loadUsage() {
        try {
            root.usageData = JSON.parse(appUsage.text());
        } catch (e) {
            root.usageData = {};
        }
    }
    property var usageData: ({})

    FileView {
        id: appUsage
        path: "/home/apricity/.config/quickshell/launcher/usage.json"
        watchChanges: true
        onLoaded: root.loadUsage()
        onFileChanged: {
            reload();
            root.loadUsage();
        }
    }

    function recordLaunch(appId) {
        var data = usageData;
        data[appId] = (data[appId] || 0) + 1;
        appUsage.setText(JSON.stringify(data));
    }

    PanelWindow { // qmllint disable uncreatable-type
        visible: root.launcherOpen
        color: "transparent"
        anchors {
            top: true
            bottom: true
            left: true
            right: true
        }
        exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

        Component.onCompleted: {
            if (this.WlrLayershell != null) {
                this.WlrLayershell.layer = WlrLayer.Top;
            }
        }

        ScriptModel {
            id: sortedApps
            values: {
                var data = root.usageData;
                return [...DesktopEntries.applications.values].filter(a => a.name.toLowerCase().includes(searchInput.text.toLowerCase())).sort((a, b) => {
                    var countA = data[a.id] || 0;
                    var countB = data[b.id] || 0;

                    if (searchInput.text === "") {
                        if (countB !== countA)
                            return countB - countA;
                    }
                    return a.name.localeCompare(b.name);
                });
            }
        }

        Rectangle {
            width: parent.width * .55
            height: parent.height * .6
            anchors.centerIn: parent
            color: root.colBg
            radius: root.radius

            ColumnLayout {
                anchors.fill: parent
                spacing: 8

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 40
                    Layout.margins: 8
                    radius: root.radius
                    border.width: root.borderWidth
                    border.color: root.colSearchBorder
                    color: root.colFg

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 8

                        Text {
                            text: "Search: "
                            font: root.searchFont
                            color: root.colSearchFont
                        }

                        TextInput {
                            id: searchInput
                            onTextChanged: appGrid.currentIndex = 0
                            Layout.fillWidth: true
                            verticalAlignment: TextInput.AlignVCenter
                            focus: true
                            font: root.searchFont
                            color: root.colSearchFont
                            onActiveFocusChanged: {
                                if (!activeFocus)
                                    forceActiveFocus();
                            }
                            cursorVisible: true
                            Keys.onPressed: event => {
                                if (event.key == Qt.Key_Up) {
                                    appGrid.moveCurrentIndexUp();
                                    event.accepted = true;
                                }
                                if (event.key == Qt.Key_Down) {
                                    appGrid.moveCurrentIndexDown();
                                    event.accepted = true;
                                }
                                if (event.key == Qt.Key_Left) {
                                    appGrid.moveCurrentIndexLeft();
                                    event.accepted = true;
                                }
                                if (event.key == Qt.Key_Right) {
                                    appGrid.moveCurrentIndexRight();
                                    event.accepted = true;
                                }
                                if (event.key == Qt.Key_Escape) {
                                    internal.close();
                                }
                                if (event.key == Qt.Key_Return || event.key == Qt.Key_Enter) {
                                    appGrid.launchCurrentItem();
                                }
                            }
                        }
                    }
                }

                GridView {
                    id: appGrid
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 20
                    clip: true
                    cellWidth: width / root.amountOfColumns
                    cellHeight: 80
                    keyNavigationEnabled: true
                    keyNavigationWraps: true
                    highlightFollowsCurrentItem: true
                    function launchCurrentItem() {
                        if (sortedApps.values[currentIndex].runInTerminal) {
                            root.recordLaunch(sortedApps.values[currentIndex].id);
                            Quickshell.execDetached({
                                command: [root.terminal, sortedApps.values[currentIndex].command],
                                workingDirectory: sortedApps.values[currentIndex].workingDirectory
                            });
                            internal.close();
                        } else {
                            root.recordLaunch(sortedApps.values[currentIndex].id);
                            sortedApps.values[currentIndex].execute();
                            internal.close();
                        }
                    }
                    highlight: Rectangle {
                        color: root.colHighlight
                        border.color: root.colHighlightBorder
                        border.width: root.borderWidth
                        radius: root.radius
                        z: 2

                        Behavior on x {
                            SpringAnimation {
                                spring: 3
                                damping: 0.2
                            }
                        }
                        Behavior on y {
                            SpringAnimation {
                                spring: 3
                                damping: 0.2
                            }
                        }
                    }

                    model: sortedApps

                    delegate: Rectangle {
                        id: application
                        required property var modelData
                        required property int index
                        width: appGrid.cellWidth - 8
                        height: appGrid.cellHeight - 8
                        border.width: root.borderWidth
                        border.color: root.colEntryBorder
                        radius: root.radius
                        z: 0
                        color: root.colFg

                        MouseArea {
                            anchors.fill: parent
                            hoverEnabled: true

                            onClicked: {
                                appGrid.currentIndex = application.index;
                            }
                            onDoubleClicked: {
                                appGrid.launchCurrentItem();
                            }
                        }

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 8
                            spacing: 8

                            IconImage {
                                implicitSize: 32
                                Layout.alignment: Qt.AlignVCenter
                                source: Quickshell.iconPath(application.modelData.icon, true)
                                visible: source !== ""
                            }

                            Text {
                                Layout.alignment: Qt.AlignVCenter
                                Layout.fillWidth: true
                                elide: Text.ElideRight
                                text: application.modelData.name
                                font: root.entryFont
                                color: root.colEntryFont
                            }
                        }
                    }
                }
            }
        }
    }
}
