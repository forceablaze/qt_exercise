import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Window {
    id: root
    visible: true

    //visibility: Window.FullScreen
    width: 1920; height: 720

    property var baseDegrees: 45
    property var totalDegrees: 270

    property var speed: 30
    property var needle_x: 360
    property var needle_y: 45

    property var rpmMaximum: 8000
    property var rpm: 0
    property var degrees: (totalDegrees / rpmMaximum) * rpm
    property var oldDegrees: 0

    property bool isAccelerating: false
    property bool isDecelerating: false

    FontLoader { id: monoBoldFont; source: "assets/DejaVuSansMono-Bold.ttf" }

    Image {
        anchors.fill: parent
        source: "assets/background.png"
    }

    Image {
        anchors.centerIn: parent
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

    Item {
        id: needleContainer
        anchors.centerIn: parent

        /* the size of gauge */
        width: 620; height: 620

        rotation: root.baseDegrees + root.degrees

        property var rotateSpeed: 8000 / 270

        Behavior on rotation {
            NumberAnimation {
                duration: needleContainer.rotateSpeed
            }
        }

        Image {
            id: needle
            visible: !needle_red.visible
            source: "assets/needle.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
        }

        Image {
            id: needle_red
            visible: isRedNeedleVisible()
            source: "assets/needle_red.png"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10


            function isRedNeedleVisible() {
                if(root.rpm >= 6500)
                  return true
                return false
            }
        }
    }

    Item {
        anchors.fill: parent
        focus: true

        Keys.onPressed: {
            if(event.key == Qt.Key_Up) {
                root.isAccelerating = true

                root.oldDegrees = (totalDegrees / rpmMaximum) * root.rpm

                if(root.rpm + 100 >= root.rpmMaximum)
                    root.rpm = root.rpmMaximum
                else
                    root.rpm += 100

                event.accepted = true
                calculateSpeed()
            }
            else if(event.key == Qt.Key_Down) {
                root.isDecelerating = true

                if(root.rpm - 10 <= 0)
                    root.rpm = 0
                else
                    root.rpm -= 10

                event.accepted = true
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

    function calculateSpeed() {
        if(root.rpm >= root.rpmMaximum)
            root.speed = 200
        else if(root.rpm <= 0)
            root.speed = 0
        else
            root.speed += 1
    }

    onIsAcceleratingChanged: {
        console.log(root.isAccelerating)
    }

    onIsDeceleratingChanged: {
        console.log(root.isDecelerating)
    }

    Component.onCompleted: {
        root.speed = 0
        root.rpm = 0
    }
}
