import QtQuick

Text {
    id: clock
    color: internal.defaultFontColor
    font.family: internal.defaultFontFamily
    font.pixelSize: internal.defaultFontSize
    text: Qt.formatDateTime(new Date(), "ddd, MMM dd - h:mm AP")

    Timer {
        interval: 1000
        running: true
        repeat: true
        onTriggered: clock.text = Qt.formatDateTime(new Date(), "ddd, MMM dd - h:mm AP")
    }

    QtObject {
        id: internal
        property color defaultFontColor: "black"
        property var defaultFontFamily: "Helvetica"
        property int defaultFontSize: 13
    }
}
