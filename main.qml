import QtQuick 2.9
import QtQuick.Window 2.2

Window {
    id: root
    visible: true

    width: 1920; height: 720

    /* Fixed the window size */
    maximumHeight: height
    maximumWidth: width
    minimumHeight: height
    minimumWidth: width

    property var maximumSpeed: 200
    property var speed: 0

    property var rpmMaximum: 8000
    property var rpm: 0

    /* the mininum rotation degree of the needle */
    property var baseDegrees: 45

    property var maximumDegrees: 270


    /* the rotation degree of the needle */
    property var degrees: (maximumDegrees / rpmMaximum) * rpm

    property var diffRPM: 30
    property var diffDegrees: (maximumDegrees / rpmMaximum) * diffRPM
    property var baseDurationSpeed: 8000 / 270

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

    /* the speed text and the unit text */
    Item {
        anchors {
            verticalCenter: parent.verticalCenter
            horizontalCenter: parent.horizontalCenter
        }

        Text {
            id: speed
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.verticalCenter

            /* float to int */
            text: root.speed | 0

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

        NumberAnimation {
            id: needleAnimation
            target: needleContainer
            properties: "rotation"
            duration: baseDurationSpeed * diffDegrees
            to: root.baseDegrees + root.degrees
        }

        /* the green needle */
        Image {
            id: needle
            visible: !needle_red.visible
            source: "assets/needle.png"

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
        }

        /* the red needle */
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
                event.accepted = true
            }
            else if(event.key == Qt.Key_Down) {
                root.isDecelerating = true
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

    Timer {
        id: timer

        /* 0.01 seconds */
        interval: 10
        repeat: true
        running: true
        triggeredOnStart: true

        onTriggered: {
            var accel = 0
            if(root.isAccelerating) {

                if(root.rpm + diffRPM >= root.rpmMaximum)
                    root.rpm = root.rpmMaximum
                else
                    root.rpm += diffRPM

                needleAnimation.start()

                accel = 0.8
            }

            if(root.isDecelerating) {
                if(root.rpm - diffRPM <= 0)
                    root.rpm = 0
                else
                    root.rpm -= diffRPM

                needleAnimation.start()

                accel = -0.8
            }

            calculateSpeed(accel)
        }
    }

    function calculateSpeed(accel) {
        if(root.rpm >= root.rpmMaximum) {
            root.speed = 200
            return
        }
        else if(root.rpm <= 0) {
            root.speed = 0
            return
        }

        if(root.speed + accel >= root.maximumSpeed) {
            root.speed = 200
            return
        }
        if(root.speed + accel <= 0) {
            root.speed = 0
            return
        }

        root.speed += accel
    }


    /* set the initial value */
    Component.onCompleted: {
        root.speed = 0
        root.rpm = 0
        needleContainer.rotation = root.baseDegrees
    }
}
