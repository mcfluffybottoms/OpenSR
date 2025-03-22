import QtQuick 2.3
import OpenSR 1.0
import OpenSR.World 1.0

Item {
    id: view
    property PlanetarySystem system
    property int speed: 500
    property int bgSpeed: 10
    property int scrollSize: 10
    property int radarViewWidth: 150
    property int maxScrollTime: 600

    property var trajectoryView

    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: "black"
    }

    Item {
        x: parent.width / 2
        y: parent.height / 2

        Image {
            id: bg
            source: system ? system.style.background : ""
            x: -width / 2
            y: -height / 2
            cache: false
        }

        Item {
            id: spaceNode
            //transform: Scale {xScale: 0.25; yScale: 0.25}
        }
    }

    Item {
        id: radarView
        anchors.right: parent.right
        anchors.top: parent.top

        width: radarViewWidth
        height: width

        Image {
            source: "res:/DATA/PanelSpace2/1RadarA.gi"
            anchors.fill: parent
            cache: true
        }
        Button {
            id: radarCenterButton
            anchors.bottom: parent.bottom
            anchors.right: parent.right
            normalImage: "res:/DATA/PanelSpace2/1CenterN.gi"
            hoveredImage: "res:/DATA/PanelSpace2/1CenterA.gi"
            downImage: "res:/DATA/PanelSpace2/1CenterD.gi"
            onClicked: console.log("Centering not implemented")
        }
    }

    onSystemChanged: {
        for (var i in spaceNode.children) {
            spaceNode.children[i].destroy();
        }

        if (!system)
            return;

        var component = Qt.createComponent("SpaceObjectItem.qml");

        var o = component.createObject(spaceNode, {
            object: system,
            mouseDelta: 50
        });
        o.entered.connect(showDebugTooltip);
        o.exited.connect(hideDebugTooltip);
        for (var c in system.children) {
            o = component.createObject(spaceNode, {
                object: system.children[c]
            });
            o.entered.connect(showDebugTooltip);
            o.exited.connect(hideDebugTooltip);
            o.entered.connect(showTrajectory);
            o.exited.connect(hideTrajectory);
        }

        var trajComponent = Qt.createComponent("TrajectoryItem.qml");
        trajectoryView = trajComponent.createObject(spaceNode, {
            object: system.children[0],
            visible: false
        });
    }

    DebugTooltip {
        id: debug
        visible: false
    }

    function showTrajectory(object) {
        trajectoryView.visibleRect = spaceNode.mapFromItem(view, 0, 0, view.width, view.height);
        if (trajectoryView.object !== object)
            trajectoryView.object = object;
        trajectoryView.visible = true;
    }
    function hideTrajectory() {
        trajectoryView.visible = false;
    }

    function showDebugTooltip(object) {
        debug.object = object;
        debug.visible = true;
    }
    function hideDebugTooltip() {
        debug.object = null;
        debug.visible = false;
    }

    ParallelAnimation {
        id: hAnim
        PropertyAnimation {
            id: hBgAnim
            target: bg
            property: "x"
            duration: maxScrollTime * 1000
            alwaysRunToEnd: false
        }
        PropertyAnimation {
            id: hFgAnim
            target: spaceNode
            property: "x"
            duration: maxScrollTime * 1000
            alwaysRunToEnd: false
        }
    }
    ParallelAnimation {
        id: vAnim
        PropertyAnimation {
            id: vBgAnim
            target: bg
            property: "y"
            duration: maxScrollTime * 1000
            alwaysRunToEnd: false
        }
        PropertyAnimation {
            id: vFgAnim
            target: spaceNode
            property: "y"
            duration: maxScrollTime * 1000
            alwaysRunToEnd: false
        }
    }

    // TrajectoryItem {
    //     id: playerTrajectoryView
    //     //anchors.fill: parent
    //     alwaysVisible: true
    //     anchors.fill: parent

    //     function updateVRect() {
    //         visibleRect = spaceNode.mapFromItem(view, 0, 0, view.width, view.height);
    //         console.log("player Vrect = ", visibleRect);
    //     }

    //     function updateTraj() {
    //         updateVRect();
    //         object = null;
    //         object = WorldManager.context.playerShip
    //     }
    // }

    MouseArea {
        id: spaceMouseOverlay
        anchors.fill: parent
        
        propagateComposedEvents: true

        onClicked: {
            if (mouse.button !== Qt.LeftButton)
                return;

            mouse.accepted = true;

            console.log("left clicked in space")
            //console.log(World.context.playerShip)
            
            var positionInSpaceNode = mapToItem(spaceNode, mouse.x, mouse.y);

            console.log("For parent: " + positionInSpaceNode )
            World.context.playerShip.evalTrajectoryTo(positionInSpaceNode);
            World.context.playerShip.destination = positionInSpaceNode;
            
            //playerTrajectoryView.updateTraj();
        }
    }

    MouseArea {
        id: leftHoverArea

        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        anchors.topMargin: scrollSize
        anchors.bottomMargin: scrollSize

        width: scrollSize

        hoverEnabled: true
        onEntered: {
            hBgAnim.to = bg.x + maxScrollTime * bgSpeed;
            hFgAnim.to = spaceNode.x + maxScrollTime * speed;
            hAnim.start();
        }
        onExited: {
            hAnim.stop();
        }
    }
    MouseArea {
        id: rightHoverArea

        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom

        anchors.topMargin: scrollSize
        anchors.bottomMargin: scrollSize

        width: scrollSize

        hoverEnabled: true
        onEntered: {
            hBgAnim.to = bg.x - maxScrollTime * bgSpeed;
            hFgAnim.to = spaceNode.x - maxScrollTime * speed;
            hAnim.start();
        }
        onExited: {
            hAnim.stop();
        }
    }
    MouseArea {
        id: topHoverArea

        anchors.top: parent.top
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.leftMargin: scrollSize
        anchors.rightMargin: scrollSize

        height: scrollSize

        hoverEnabled: true
        onEntered: {
            vBgAnim.to = bg.y + maxScrollTime * bgSpeed;
            vFgAnim.to = spaceNode.y + maxScrollTime * speed;
            vAnim.start();
        }
        onExited: {
            vAnim.stop();
        }
    }
    MouseArea {
        id: bottomHoverArea

        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        anchors.leftMargin: scrollSize
        anchors.rightMargin: scrollSize

        height: scrollSize

        hoverEnabled: true
        onEntered: {
            vBgAnim.to = bg.y - maxScrollTime * bgSpeed;
            vFgAnim.to = spaceNode.y - maxScrollTime * speed;
            vAnim.start();
        }
        onExited: {
            vAnim.stop();
        }
    }
    MouseArea {
        id: topleftHoverArea

        anchors.left: parent.left
        anchors.top: parent.top

        width: scrollSize
        height: scrollSize

        hoverEnabled: true
        onEntered: {
            hBgAnim.to = bg.x + maxScrollTime * bgSpeed / Math.sqrt(2);
            hFgAnim.to = spaceNode.x + maxScrollTime * speed / Math.sqrt(2);
            vBgAnim.to = bg.y + maxScrollTime * bgSpeed / Math.sqrt(2);
            vFgAnim.to = spaceNode.y + maxScrollTime * speed / Math.sqrt(2);
            hAnim.start();
            vAnim.start();
        }
        onExited: {
            hAnim.stop();
            vAnim.stop();
        }
    }
    MouseArea {
        id: toprightHoverArea

        anchors.right: parent.right
        anchors.top: parent.top

        width: scrollSize
        height: scrollSize

        hoverEnabled: true
        onEntered: {
            hBgAnim.to = bg.x - maxScrollTime * bgSpeed / Math.sqrt(2);
            hFgAnim.to = spaceNode.x - maxScrollTime * speed / Math.sqrt(2);
            vBgAnim.to = bg.y + maxScrollTime * bgSpeed / Math.sqrt(2);
            vFgAnim.to = spaceNode.y + maxScrollTime * speed / Math.sqrt(2);
            hAnim.start();
            vAnim.start();
        }
        onExited: {
            hAnim.stop();
            vAnim.stop();
        }
    }
    MouseArea {
        id: bottomleftHoverArea

        anchors.left: parent.left
        anchors.bottom: parent.bottom

        width: scrollSize
        height: scrollSize

        hoverEnabled: true
        onEntered: {
            hBgAnim.to = bg.x + maxScrollTime * bgSpeed / Math.sqrt(2);
            hFgAnim.to = spaceNode.x + maxScrollTime * speed / Math.sqrt(2);
            vBgAnim.to = bg.y - maxScrollTime * bgSpeed / Math.sqrt(2);
            vFgAnim.to = spaceNode.y - maxScrollTime * speed / Math.sqrt(2);
            hAnim.start();
            vAnim.start();
        }
        onExited: {
            hAnim.stop();
            vAnim.stop();
        }
    }
    MouseArea {
        id: bottomrightHoverArea

        anchors.right: parent.right
        anchors.bottom: parent.bottom

        width: scrollSize
        height: scrollSize

        hoverEnabled: true
        onEntered: {
            hBgAnim.to = bg.x - maxScrollTime * bgSpeed / Math.sqrt(2);
            hFgAnim.to = spaceNode.x - maxScrollTime * speed / Math.sqrt(2);
            vBgAnim.to = bg.y - maxScrollTime * bgSpeed / Math.sqrt(2);
            vFgAnim.to = spaceNode.y - maxScrollTime * speed / Math.sqrt(2);
            hAnim.start();
            vAnim.start();
        }
        onExited: {
            hAnim.stop();
            vAnim.stop();
        }
    }

    Button {
        id: turnButton
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        text: "Turn"
        onClicked: WorldManager.startTurn()
    }
}
