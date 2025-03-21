import QtQuick 2.0
import OpenSR 1.0

Item {
    
    Rectangle {
        width: 30
        height: 30
        color: "red"
        border.color: "black"
        border.width: 5
        radius: 5
    }
    BorderImage {
        id: bg
        width: 410
        height: 617
        anchors.fill: parent
        source: backLeftImage
    }
}