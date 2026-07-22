pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import Quickshell.Io
import "../widgets"

PanelWindow { // qmllint disable uncreatable-type
    id: root
    required property var screen

    color: "transparent"
    visible: false

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    anchors {
        left: true
        top: true
        bottom: true
    }
    implicitWidth: 32 + 8 + 4

    readonly property real barWidth: 32 + 8 + 4
    property real contentSlide: -barWidth
    property bool sidebarMode: false

    Behavior on contentSlide {
        NumberAnimation {
            duration: 200
            easing.type: Easing.OutCubic
        }
    }

    function slideIn(fullSidebar) {
        sidebarMode = fullSidebar;
        osdPill.osdOnly = !fullSidebar;
        if (fullSidebar) {
            batteryWidget.visible = true;
            sysTray.visible = true;
        } else {
            batteryWidget.visible = false;
            sysTray.visible = false;
        }
        contentSlide = -barWidth;
        visible = true;
        Qt.callLater(() => { root.contentSlide = 0; });
    }

    function slideOut() {
        contentSlide = -barWidth;
        hideTimer.restart();
    }

    Timer {
        id: hideTimer
        interval: 200
        onTriggered: root.visible = false
    }

    Item {
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: root.barWidth
        clip: true

        ColumnLayout {
            x: root.contentSlide
            width: root.barWidth
            height: parent.height
            spacing: 4

            Item {
                Layout.fillHeight: true
            }

            OsdPill {
                id: osdPill
                Layout.alignment: Qt.AlignHCenter
            }

            BatteryWidget {
                id: batteryWidget
                visible: root.sidebarMode
                Layout.alignment: Qt.AlignHCenter
            }

            SysTray {
                id: sysTray
                visible: root.sidebarMode
                Layout.alignment: Qt.AlignHCenter
                window: root
            }

            Item {
                Layout.fillHeight: true
            }
        }
    }

    Timer {
        id: clockTimer
        interval: 1000
        running: true
        repeat: true
        triggeredOnStart: true
        onTriggered: osdPill.clockText.text = Qt.formatTime(new Date(), "hh\nmm")
    }

    Timer {
        id: autoHideTimer
        interval: 2000
        onTriggered: root.slideOut()
    }

    Connections {
        target: osdPill
        function onOsdTriggered() {
            if (root.visible && root.contentSlide >= 0 && root.sidebarMode) {
                autoHideTimer.stop();
            } else {
                root.slideIn(false);
                autoHideTimer.restart();
            }
        }
    }

    IpcHandler {
        target: "sidebar"
        function toggle() {
            if (root.visible && root.contentSlide >= 0) {
                root.slideOut();
            } else {
                root.slideIn(true);
            }
            autoHideTimer.stop();
        }
        function show() {
            root.slideIn(true);
            autoHideTimer.stop();
        }
        function hide() {
            root.slideOut();
            autoHideTimer.stop();
        }
    }
}
