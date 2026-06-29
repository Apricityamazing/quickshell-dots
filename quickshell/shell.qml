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
    color: tokyonight.colBg

    // qmlformat off
    property font font: Qt.font({
    family: "JetBrainsMono Nerd Font",
    pixelSize: 14
  })
    // Themes
    QtObject {
      id: tokyonight
    property color colBg:             "#1A1B26"
    property color colFg:             "#C0CAF5"
    property color colActiveBorder:   "#7AA2F7"
    property color colInactiveBorder: "#292E42"
    property color colBlack:          "#15161E"
    property color colLightRed:       "#F7768E"
    property color colDarkLime:       "#9ECE6A"
    property color colOrange:         "#E0AF68"
    property color colBlue:           "#7AA2F7"
    property color colPurple:         "#BB9AF7"
    property color colTurqoise:       "#7DCFFF"
    property color colLightGray:      "#A9B1D6"
    property color colMuted:          "#414868"
    property color colPink:           "#FF899D"
    property color colLightLime:      "#9FE044"
    property color colLightOrange:    "#FABA4A"
    property color colBlueGrey:       "#8DB0FF"
    property color colLightPurple:    "#C7A9FF"
    property color colLightCyan:      "#A4DAFF"
    property color colBarelyGrey:     "#C0CAF5"
    property color colDarkOrange:     "#FF9E64"
    property color colRed:            "#DB4B4B"
    }

    QtObject {
      id: everforest
    property color colBg:             "#4F5B58"
    property color colFg:             "#D3C6AA"
    property color colActiveBorder:   "#A7C080"
    property color colInactiveBorder: "#DBBC7F"
    property color colBlack:          "#1E2326"
    property color colLightRed:       "#E67E80"
    property color colGreen:          "#A7C080"
    property color colOrange:         "#E69875"
    property color colBlue:           "#7FBBB3"
    property color colPurple:         "#D699B6"
    property color colAqua:           "#83C092"
    property color colLightGray:      "#9DA9A0"
    property color colGray:           "#859289"
    property color colDarkGray:       "#7A8478"
    property color colMuted:          "#2E383C"
  }
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
                    activeWorkspaceColor: tokyonight.colBarelyGrey
                    inactiveWorkspaceColor: tokyonight.colTurqoise
                    emptyInactiveWorkspaceColor: tokyonight.colBlue
                    font.family: root.font.family
                    font.pixelSize: root.font.pixelSize
                    font.bold: true
                }

                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: tokyonight.colMuted
                }

                IdleInhibitor {
                    importantWindow: root
                    font.family: root.font.family
                    font.pixelSize: root.font.pixelSize
                    textColor: tokyonight.colDarkLime
                }

                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: tokyonight.colMuted
                }

                Tray {
                    id: tray
                    shellWindow: root
                    visible: trayVisible
                }

                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: tokyonight.colMuted
                    visible: tray.trayVisible
                }

                NetworkBarWidget {
                    color: tokyonight.colPurple
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
                color: tokyonight.colDarkOrange
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
                    color: tokyonight.colPink
                    font.family: root.font.family
                    font.pixelSize: root.font.pixelSize
                    font.bold: true
                }

                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: tokyonight.colMuted
                }

                CpuWidget {
                    color: tokyonight.colTurqoise
                    font.family: root.font.family
                    font.pixelSize: root.font.pixelSize
                    font.bold: true
                }

                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: tokyonight.colMuted
                }

                MemoryWidget {
                    color: tokyonight.colLightPurple
                    font.family: root.font.family
                    font.pixelSize: root.font.pixelSize
                    font.bold: true
                }

                Rectangle {
                    implicitWidth: 1
                    implicitHeight: 16
                    color: tokyonight.colMuted
                }

                ClockWidget {
                    color: tokyonight.colBarelyGrey
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
        colBg: tokyonight.colBg
        colFg: tokyonight.colFg
        fontColor: tokyonight.colPurple
        centerAppNameFont.italic: true
    }
    AppLauncher {
        colBg: Qt.alpha(Qt.lighter(tokyonight.colBg, 1.5), 0.7)
        colFg: Qt.alpha(tokyonight.colFg, 0.7)
        amountOfColumns: 3
        terminal: "kitty"
        colEntryFont: tokyonight.colBlack
        entryBorderWidth: 0
        colHighlight: Qt.alpha(tokyonight.colPurple, 0.4)
        colHighlightBorder: Qt.darker(tokyonight.colPurple, 1.4)
        defaultFont: root.font
    }
    NetworkWidget {
        font: root.font
    }
}
