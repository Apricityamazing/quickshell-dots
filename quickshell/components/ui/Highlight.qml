import QtQuick

Item {
    id: root

    property Item target: null
    property int inset: 0 // gap between edge and the target's edge

    property color fillColor: "transparent"
    property color strokeColor: "transparent"
    property real strokeWidth: 0
    property int radius: 0
    property int moveDuration: 120

    visible: target !== null

    x: target ? target.x + inset : 0
    y: target ? target.y + inset : 0
    width: target ? Math.max(0, target.width - inset * 2) : 0
    height: target ? Math.max(0, target.height - inset * 2) : 0

    // Stops the animation of x when the selection wraps to a new row
    // It otherwise slides backwards across the entire row
    property int lastY: -1
    Behavior on x {
        SpringAnimation {
            spring: 2
            damping: 0.25
        }
    }
    Behavior on y {
        SpringAnimation {
            spring: 2
            damping: 0.25
        }
    }
    onTargetChanged: lastY = target ? target.y : -1

    Rectangle {
        anchors.fill: parent
        radius: root.radius
        color: root.fillColor
        border.color: root.strokeColor
        border.width: root.strokeWidth
    }
}
