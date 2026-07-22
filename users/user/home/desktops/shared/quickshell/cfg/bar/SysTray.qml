pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    color: "#000000"
    radius: 16
    Layout.alignment: Qt.AlignHCenter
    implicitWidth: 32
    implicitHeight: sysTrayLayout.height
    visible: SystemTray.items.values.length > 0
    required property PanelWindow window

    ColumnLayout {
        id: sysTrayLayout
        anchors.centerIn: parent
        spacing: -8

        Repeater {
            model: SystemTray.items.values

            delegate: Rectangle {
                id: trayDelegate
                required property var modelData
                readonly property var trayItem: trayDelegate.modelData

                color: "transparent"
                implicitWidth: 32
                implicitHeight: 32
                Layout.alignment: Qt.AlignHCenter

                Image {
                    id: iconImage
                    anchors.centerIn: parent
                    width: 16
                    height: 16
                    sourceSize.width: iconImage.width
                    sourceSize.height: iconImage.height
                    source: trayDelegate.trayItem.iconName ? trayDelegate.trayItem.iconName : trayDelegate.trayItem.icon
                    layer.enabled: true
                    layer.effect: MultiEffect {
                        colorization: 1.0
                        colorizationColor: "#FFFFFF"
                    }
                }

                MouseArea {
                    id: trayItemArea
                    anchors.fill: parent
                    hoverEnabled: true
                    cursorShape: Qt.PointingHandCursor
                    acceptedButtons: Qt.LeftButton | Qt.RightButton | Qt.MiddleButton
                    onClicked: mouse => {
                        if (mouse.button === Qt.LeftButton) {
                            if (trayDelegate.trayItem.onlyMenu)
                                trayDelegate.trayItem.display(root.window, mouse.x, mouse.y);
                            else
                                trayDelegate.trayItem.activate();
                        } else if (mouse.button === Qt.RightButton) {
                            const pos = trayItemArea.mapToItem(null, mouse.x, mouse.y);
                            trayDelegate.trayItem.display(root.window, pos.x, pos.y);
                        } else if (mouse.button === Qt.MiddleButton) {
                            trayDelegate.trayItem.secondaryActivate();
                        }
                    }
                    onWheel: wheel => {
                        trayDelegate.trayItem.scroll(wheel.angleDelta.y > 0 ? 1 : -1, false);
                    }
                }
            }
        }
    }
}
