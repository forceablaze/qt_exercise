import QtQuick 2.9
import QtQuick.Window 2.2
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4

Window {
    visible: true
    visibility: Window.FullScreen
    width: 1920
    height: 720

    Image {
        anchors.fill: parent
        source: "assets/background.png"
    }

    Image {
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        source: "assets/gauge.png"
    }
}
