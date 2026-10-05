import QtQuick
import "../../services"

Text {
    text: BrightnessService.brightnessIcon + " " + BrightnessService.currentBrightness
    font: internal.defaultFont
    QtObject {
        id: internal
        property font defaultFont: Qt.font({
            family: "Helvetica",
            pixelSize: 13,
            bold: true
        })
    }
}
