import QtQuick

Text {
    text: "Mem: " + MemoryService.memUsage + "%"
    color: internal.defaultFontColor
    font.family: internal.defaultFontFamily
    font.pixelSize: internal.defaultFontSize
    font.bold: true

    QtObject {
        id: internal
        property color defaultFontColor: "black"
        property var defaultFontFamily: "Helvetica"
        property int defaultFontSize: 13
    }
}
