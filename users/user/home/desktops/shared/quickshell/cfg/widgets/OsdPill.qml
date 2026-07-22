pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

Rectangle {
    id: root
    color: "#000000"
    radius: 16
    Layout.alignment: Qt.AlignHCenter
    implicitWidth: 32
    implicitHeight: showOsd ? 140 : clockText.height + (12 + 2) + 12
    clip: true

    Behavior on implicitHeight {
        NumberAnimation {
            duration: 300
            easing.type: Easing.InOutQuad
        }
    }

    signal osdTriggered(string mode)

    property string currentMode: "none"
    property bool showOsd: currentMode !== "none"
    property bool osdOnly: false

    property real displayBrightness: -1
    property real kbdBrightness: -1

    property real osdValue: {
        if (currentMode === "volume")
            return Pipewire.defaultAudioSink?.audio?.volume ?? 0;
        if (currentMode === "brightness")
            return displayBrightness === -1 ? 0 : displayBrightness;
        if (currentMode === "kbd")
            return kbdBrightness === -1 ? 0 : kbdBrightness;
        return 0;
    }

    property string osdIcon: {
        if (currentMode === "volume") {
            let audio = Pipewire.defaultAudioSink?.audio;
            if (!audio || audio.muted)
                return Quickshell.iconPath("audio-volume-muted-panel");
            let v = audio.volume;
            if (v < 0.25)
                return Quickshell.iconPath("audio-volume-low-panel");
            if (v < 0.5)
                return Quickshell.iconPath("audio-volume-medium-panel");
            return Quickshell.iconPath("audio-volume-high-panel");
        }
        if (currentMode === "brightness") {
            if (osdValue < 0.33)
                return Quickshell.iconPath("display-brightness-low-panel");
            if (osdValue < 0.66)
                return Quickshell.iconPath("display-brightness-medium-panel");
            return Quickshell.iconPath("display-brightness-high-panel");
        }
        if (currentMode === "kbd") {
            return Quickshell.iconPath("input-keyboard-brightness-symbolic");
        }
        return "";
    }

    function triggerOsd(mode) {
        currentMode = mode;
        osdTimer.restart();
        osdTriggered(mode);
    }

    Timer {
        id: osdTimer
        interval: 2000
        onTriggered: root.currentMode = "none"
    }

    PwObjectTracker {
        objects: [Pipewire.defaultAudioSink]
    }
    Connections {
        target: Pipewire.defaultAudioSink?.audio || null

        property real lastVol: -1

        function onVolumeChanged() {
            let v = target.volume;
            if (lastVol !== -1 && lastVol !== v)
                root.triggerOsd("volume");
            lastVol = v;
        }
        function onMutedChanged() {
            root.triggerOsd("volume");
        }
    }

    Process {
        command: ["sh", "-c", "while true; do brightnessctl -m 2>/dev/null; sleep 0.1; done"]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                let parts = data.trim().split(",");
                if (parts.length >= 4) {
                    let v = parseFloat(parts[3].replace("%", "")) / 100.0;
                    if (root.displayBrightness !== -1 && root.displayBrightness !== v) {
                        root.displayBrightness = v;
                        root.triggerOsd("brightness");
                    } else {
                        root.displayBrightness = v;
                    }
                }
            }
        }
    }

    Process {
        command: ["sh", "-c", "while true; do brightnessctl -d '*kbd_backlight*' -m 2>/dev/null; sleep 0.1; done"]
        running: true
        stdout: SplitParser {
            splitMarker: "\n"
            onRead: data => {
                let parts = data.trim().split(",");
                if (parts.length >= 4) {
                    let v = parseFloat(parts[3].replace("%", "")) / 100.0;
                    if (root.kbdBrightness !== -1 && root.kbdBrightness !== v) {
                        root.kbdBrightness = v;
                        root.triggerOsd("kbd");
                    } else {
                        root.kbdBrightness = v;
                    }
                }
            }
        }
    }

    Item {
        anchors.fill: parent
        opacity: root.showOsd ? 0 : 1
        visible: opacity > 0

        Behavior on opacity {
            enabled: !root.osdOnly
            NumberAnimation {
                duration: 300
            }
        }

        Text {
            id: clockText
            anchors {
                centerIn: parent
                horizontalCenterOffset: 2
                verticalCenterOffset: 2
            }
            color: "white"
            font.pixelSize: 16
            font.weight: 200
            horizontalAlignment: Text.AlignHCenter
            font.family: "Bitcount Grid Single"
        }
    }

    Item {
        anchors.fill: parent
        opacity: root.showOsd ? 1 : 0
        visible: opacity > 0

        Behavior on opacity {
            NumberAnimation {
                duration: 300
            }
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.topMargin: 12
            anchors.bottomMargin: 12
            spacing: 8

            Image {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
                sourceSize.width: 16
                sourceSize.height: 16
                source: root.osdIcon
            }

            Rectangle {
                Layout.alignment: Qt.AlignHCenter
                Layout.fillHeight: true
                Layout.preferredWidth: 4
                radius: 2
                color: "#333333"

                Rectangle {
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: parent.height * Math.min(Math.max(0, root.osdValue), 1)
                    radius: 2
                    color: "white"

                    Behavior on height {
                        NumberAnimation {
                            duration: 150
                            easing.type: Easing.OutQuad
                        }
                    }
                }
            }

            Text {
                Layout.alignment: Qt.AlignHCenter
                color: "#888"
                font.pixelSize: 10
                text: Math.round(root.osdValue * 100) + "%"
            }
        }
    }

    property alias clockText: clockText
}
