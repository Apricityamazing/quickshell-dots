//@ pragma UseQApplication
import Quickshell
import Quickshell.Hyprland
import QtQuick
import QtQuick.Layouts

PanelWindow { // qmllint disable uncreatable-type
    id: root

    anchors.top: true
    anchors.left: true
    anchors.right: true
    implicitHeight: 30
    color: colBg

    // qmlformat off
    property font font: Qt.font({
    family: "JetBrainsMono Nerd Font",
    pixelSize: 14
  })
    // Theme
    property color colBg:             "#1a1b26"
    property color colFg:             "#c0caf5"
    property color colActiveBorder:   "#7aa2f7"
    property color colInactiveBorder: "#292e42"
    property color colBlack:          "#15161e"
    property color colLightRed:       "#f7768e"
    property color colDarkLime:       "#9ece6a"
    property color colOrange:         "#e0af68"
    property color colBlue:           "#7aa2f7"
    property color colPurple:         "#bb9af7"
    property color colTurqoise:       "#7dcfff"
    property color colLightGray:      "#a9b1d6"
    property color colMuted:          "#414868"
    property color colPink:           "#ff899d"
    property color colLightLime:      "#9fe044"
    property color colLightOrange:    "#faba4a"
    property color colBlueGrey:       "#8db0ff"
    property color colLightPurple:    "#c7a9ff"
    property color colLightCyan:      "#a4daff"
    property color colBarelyGrey:     "#c0caf5"
    property color colDarkOrange:     "#ff9e64"
    property color colRed:            "#db4b4b"
    // qmlformat on

    // Outer RowLayout splits bar into equal thirds
    RowLayout {
        anchors.fill: parent  // fill only, no centerIn
        spacing: 0

        // ── Left third ──────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredWidth: 0
            Layout.fillHeight: true
            color: "transparent"

            // Inner RowLayout anchored left, vertically centered
            RowLayout {
                anchors.left: parent.left
                anchors.leftMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                spacing: 6

                HyprlandWorkspaces {
                    activeWorkspaceColor: root.colBarelyGrey
                    inactiveWorkspaceColor: root.colTurqoise
                    emptyInactiveWorkspaceColor: root.colBlue
                    font.family: root.font.family
                    font.pixelSize: root.font.pixelSize
                    font.bold: true
                }

                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: root.colMuted
                }

                IdleInhibitor {
                    importantWindow: root
                    font.family: root.font.family
                    font.pixelSize: root.font.pixelSize
                    textColor: root.colDarkLime
                }

                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: root.colMuted
                }

                Tray {
                    id: tray
                    shellWindow: root
                    visible: trayVisible
                }

                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: root.colMuted
                    visible: tray.trayVisible
                }

                NetworkBarWidget {
                    color: root.colPurple
                    font.family: root.font.family
                    font.pixelSize: root.font.pixelSize
                    font.bold: true
                }
            }
        }

        // ── Center third ─────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredWidth: 0
            Layout.fillHeight: true
            color: "transparent"

            Text {
                anchors.centerIn: parent  // center directly in the Rectangle, no inner RowLayout needed
                text: Hyprland.activeToplevel?.title ?? ""
                wrapMode: Text.WrapAnywhere
                clip: true
                color: root.colDarkOrange
                font.family: root.font.family
                font.pixelSize: root.font.pixelSize
                font.bold: true
            }
        }

        // ── Right third ──────────────────────────────────────
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredWidth: 0
            Layout.fillHeight: true
            color: "transparent"

            // Inner RowLayout anchored right, vertically centered
            RowLayout {
                anchors.right: parent.right
                anchors.rightMargin: 4
                anchors.verticalCenter: parent.verticalCenter
                spacing: 12

                PipeWireWidget {
                    color: root.colPink
                    font.family: root.font.family
                    font.pixelSize: root.font.pixelSize
                    font.bold: true
                }

                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: root.colMuted
                }

                CpuWidget {
                    color: root.colTurqoise
                    font.family: root.font.family
                    font.pixelSize: root.font.pixelSize
                    font.bold: true
                }

                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: root.colMuted
                }

                MemoryWidget {
                    color: root.colLightPurple
                    font.family: root.font.family
                    font.pixelSize: root.font.pixelSize
                    font.bold: true
                }

                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: root.colMuted
                }

                ClockWidget {
                    color: root.colBarelyGrey
                    font.family: root.font.family
                    font.pixelSize: root.font.pixelSize
                    font.bold: true
                }
            }
        }
    }
    Notifications {
        fontSize: root.font.pixelSize
        fontFamily: root.font.family
        colBg: root.colBg
        colFg: root.colFg
        fontColor: root.colPurple
        centerAppNameFont.italic: true
    }
    AppLauncher {
        colBg: Qt.alpha(Qt.lighter(root.colBg, 1.5), 0.7)
        colFg: Qt.alpha(root.colFg, 0.7)
        amountOfColumns: 3
        terminal: "kitty"
        colEntryFont: root.colBlack
        entryBorderWidth: 0
        colHighlight: Qt.alpha(root.colPurple, 0.4)
        colHighlightBorder: Qt.darker(root.colPurple, 1.4)
        defaultFont: root.font
    }
    NetworkWidget {
        font: root.font
    }
}
