import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Window {
    id: root
    visible: true
    //visibility: Window.FullScreen
    width: 1920
    height: 720

    property var speed: 30
    property var needle_x: 360
    property var needle_y: 150
    property var degrees: 36
    property var rpm: 0

    property bool isAccelerating: false
    property bool isDecelerating: false

    FontLoader { id: monoBoldFont; source: "assets/DejaVuSansMono-Bold.ttf" }


    Image {
        anchors.fill: parent
        source: "assets/background.png"
    }

    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: "assets/gauge.png"
    }

    Item {
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: speed
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter
            text: root.speed
            font.family: monoBoldFont.name
            font.pointSize: 60
            color: "white"
        }

        Text {
            anchors.top: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter

            text: "km/h"
            font.family: monoBoldFont.name
            font.pointSize: 60
            color: "white"
        }
    }

    /* 90x300 */
    /*
      rpm: 0    -> 36 degrees
      rpm: 1000 -> 72 degrees
      rpm: 4000 -> 180 degrees
    */
    Image {
        id: needle
        source: "assets/needle.png"
        transform: Rotation {
            origin.x: root.needle_x
            origin.y: root.needle_y
            angle: root.degrees
        }
    }

    Item {
        anchors.fill: parent
        focus: true

        Keys.onPressed: {
            if(event.key == Qt.Key_Up) {
                root.isAccelerating = true
                root.rpm += 10
                console.log(root.rpm)

                event.accepted = true
            }
            else if(event.key == Qt.Key_Down) {
                root.isDecelerating = true

                root.rpm -= 10
                console.log(root.rpm)


                event.accepted = true
            }
            else if(event.key == Qt.Key_Left) {
                root.needle_x += 1
                console.log(root.needle_x)
            }
            else if(event.key == Qt.Key_Right) {
                root.needle_y += 1
                console.log(root.needle_y)
            }
        }

        Keys.onReleased: {
            if(event.isAutoRepeat)
                return

            if(event.key == Qt.Key_Up) {
                root.isAccelerating = false
                event.accepted = true
            }
            else if(event.key == Qt.Key_Down) {
                root.isDecelerating = false
                event.accepted = true
            }
        }
    }

    onIsAcceleratingChanged: {
        console.log(root.isAccelerating)
    }

    onIsDeceleratingChanged: {
        console.log(root.isDecelerating)
    }

    onSpeedChanged: {
        console.log(root.speed)
    }

    Component.onCompleted: {
        root.speed = 0
        root.rpm = 0
    }
}
