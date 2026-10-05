import "../../services"
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property font font: Qt.font({
        "family": "Helvetica",
        "pixelSize": 13,
        "bold": false,
        "italic": false,
        "weight": Font.Normal
    })
    property color color: internal.defaultColor

    implicitWidth: layout.implicitWidth
    implicitHeight: layout.implicitHeight

    QtObject {
        id: internal

        property color defaultColor: "white"
    }

    RowLayout {
        id: layout

        spacing: 4

        Text {
            visible: NetworkService.iconText !== ""
            text: NetworkService.iconText
            color: root.color
            font: root.font
        }

        Text {
            visible: NetworkService.statusText !== ""
            text: NetworkService.statusText
            color: root.color
            font: root.font
        }

    }

}
