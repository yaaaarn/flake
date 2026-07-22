pragma ComponentBehavior: Bound
import Quickshell
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    required property var notification

    color: notification?.urgency > 1 ? "#d0679d" : "#000"
    radius: 8

    // Crucial: This tells the component to clip its children
    // to the shape of this rectangle (including the radius)
    clip: true

    implicitWidth: 350
    implicitHeight: layout.implicitHeight + 16

    ColumnLayout {
        id: layout
        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
            margins: 8
        }
        spacing: 8

        RowLayout {
            Layout.fillWidth: true
            spacing: 8

            Image {
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
                sourceSize.width: 16
                sourceSize.height: 16
                source: root.notification ? Quickshell.iconPath(root.notification.appIcon) || "" : ""
                visible: root.notification && root.notification.appIcon != null && root.notification.appIcon != ""
            }

            Text {
                Layout.fillWidth: true
                color: root.notification && root.notification.urgency > 1 ? "#000" : "#fff"
                opacity: 0.5
                font.pixelSize: 11
                font.weight: Font.Bold
                text: root.notification ? root.notification.desktopEntry || root.notification.appName || "" : ""
                elide: Text.ElideRight
            }
        }

        RowLayout {
            spacing: 12
            Image {
                Layout.preferredHeight: 64
                Layout.preferredWidth: 64

                fillMode: Image.PreserveAspectFit
                source: root.notification.image
                visible: root.notification && root.notification.image != null && root.notification.image != ""
            }

            ColumnLayout {

                Text {
                    Layout.fillWidth: true
                    color: root.notification && root.notification.urgency > 1 ? "#000" : "#fff"
                    font.family: "Bitcount Grid Single"
                    font.weight: 500
                    font.pixelSize: 16
                    text: root.notification ? root.notification.summary || "" : ""
                    wrapMode: Text.Wrap
                    opacity: 0.75
                    visible: text !== ""
                }

                Text {
                    Layout.fillWidth: true
                    color: root.notification && root.notification.urgency > 1 ? "#000" : "#fff"
                    text: root.notification ? root.notification.body || "" : ""
                    wrapMode: Text.Wrap
                    visible: text !== ""
                    opacity: 0.75
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: mouse => {
            // Qualify notification here as well for safety
            if (mouse.button === Qt.RightButton) {
                root.notification.dismiss();
            } else {
                var actions = root.notification.actions;
                var invoked = false;
                for (var i = 0; i < actions.length; i++) {
                    if (actions[i].identifier === "default") {
                        actions[i].invoke();
                        invoked = true;
                        break;
                    }
                }
                if (!invoked)
                    root.notification.dismiss();
            }
        }
    }

    readonly property int defaultTimeoutMs: 10000

    Timer {
        interval: {
            if (!root.notification)
                return root.defaultTimeoutMs;
            var t = root.notification.expireTimeout;
            if (t <= 0)
                return root.defaultTimeoutMs;

            var calculatedTimeout = t * 1000;
            return Math.min(calculatedTimeout, root.defaultTimeoutMs);
        }
        running: !!root.notification && root.notification.expireTimeout !== 0 && root.notification.urgency < 2
        onTriggered: root.notification.expire()
    }
}
