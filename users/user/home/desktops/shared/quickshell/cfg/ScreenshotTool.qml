pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import Quickshell.Io
import QtQuick

Item {
    id: root

    required property var vars

    readonly property string uploadUrl: vars.uploadUrl
    readonly property string uploadPassword: vars.uploadPassword
    property bool uploadMode: false
    property string fullImagePath: "/tmp/qs-screenshot-full.png"
    property string cropOutputPath: "/tmp/qs-screenshot-crop.png"

    PanelWindow { // qmllint disable uncreatable-type
        id: overlay
        visible: false
        color: "transparent"

        anchors.top: true
        anchors.bottom: true
        anchors.left: true
        anchors.right: true

        WlrLayershell.layer: WlrLayer.Overlay
        WlrLayershell.exclusionMode: ExclusionMode.Ignore
        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive

        Image {
            id: displayImg
            anchors.fill: parent
            fillMode: Image.Stretch
            visible: status === Image.Ready
        }

        Text {
            anchors.centerIn: parent
            color: "#FFFFFF"
            font.pixelSize: 20
            text: "Loading..."
            visible: displayImg.status !== Image.Ready
        }

        property real selX: 0
        property real selY: 0
        property real selW: 0
        property real selH: 0

        readonly property color dimColor: "#60000000"
        readonly property int tweenDuration: 150
        readonly property var tweenEasing: Easing.OutQuad

        Rectangle {
            x: 0
            y: 0
            width: parent.width
            height: overlay.selY
            color: overlay.dimColor
            visible: displayImg.status === Image.Ready
        }
        Rectangle {
            x: 0
            y: overlay.selY + overlay.selH
            width: parent.width
            height: parent.height - (overlay.selY + overlay.selH)
            color: overlay.dimColor
            visible: displayImg.status === Image.Ready
        }
        Rectangle {
            x: 0
            y: overlay.selY
            width: overlay.selX
            height: overlay.selH
            color: overlay.dimColor
            visible: displayImg.status === Image.Ready
        }
        Rectangle {
            x: overlay.selX + overlay.selW
            y: overlay.selY
            width: parent.width - (overlay.selX + overlay.selW)
            height: overlay.selH
            color: overlay.dimColor
            visible: displayImg.status === Image.Ready
        }

        Rectangle {
            id: selRect
            x: overlay.selX
            y: overlay.selY
            width: overlay.selW
            height: overlay.selH
            color: "transparent"
            radius: 8
            border.color: "#FFFFFF"
            border.width: 2
            visible: overlay.selW > 0 && overlay.selH > 0

            Behavior on x {
                NumberAnimation {
                    duration: overlay.tweenDuration
                    easing.type: overlay.tweenEasing
                }
            }
            Behavior on y {
                NumberAnimation {
                    duration: overlay.tweenDuration
                    easing.type: overlay.tweenEasing
                }
            }
            Behavior on width {
                NumberAnimation {
                    duration: overlay.tweenDuration
                    easing.type: overlay.tweenEasing
                }
            }
            Behavior on height {
                NumberAnimation {
                    duration: overlay.tweenDuration
                    easing.type: overlay.tweenEasing
                }
            }

            Rectangle {
                anchors.fill: parent
                anchors.margins: -1
                color: "transparent"
                border.color: "#000000"
                border.width: 1
                radius: parent.radius + 1
            }
        }

        Item {
            anchors.fill: parent
            focus: true
            Keys.onEscapePressed: {
                root.resetState();
            }
        }

        MouseArea {
            id: ma
            anchors.fill: parent
            cursorShape: displayImg.status === Image.Ready ? Qt.CrossCursor : Qt.ArrowCursor
            enabled: displayImg.status === Image.Ready

            property real sx: 0
            property real sy: 0

            onPressed: function (mouse) {
                sx = mouse.x;
                sy = mouse.y;
                overlay.selX = mouse.x;
                overlay.selY = mouse.y;
                overlay.selW = 0;
                overlay.selH = 0;
            }

            onPositionChanged: function (mouse) {
                var x1 = Math.min(sx, mouse.x);
                var y1 = Math.min(sy, mouse.y);
                var x2 = Math.max(sx, mouse.x);
                var y2 = Math.max(sy, mouse.y);
                overlay.selX = x1;
                overlay.selY = y1;
                overlay.selW = x2 - x1;
                overlay.selH = y2 - y1;
            }

            onReleased: function (mouse) {
                if (overlay.selW < 5 && overlay.selH < 5) {
                    overlay.visible = false;
                    return;
                }
                overlay.visible = false;
                root.cropAndProcess(overlay.selX, overlay.selY, overlay.selW, overlay.selH);
            }
        }
    }

    function getScreen() {
        if (overlay.screen)
            return overlay.screen;
        if (Quickshell.screens.length > 0)
            return Quickshell.screens[0];
        return null;
    }

    function getScreenName() {
        var s = root.getScreen();
        return s ? s.name : "";
    }

    function getScreenWidth() {
        var s = root.getScreen();
        return s ? s.width : 0;
    }

    function resetState() {
        root.uploadMode = false;
        displayImg.source = "";
        captureProc.running = false;
        cropProc.running = false;
        uploadProc.running = false;
        overlay.visible = false;
        overlay.selX = 0;
        overlay.selY = 0;
        overlay.selW = 0;
        overlay.selH = 0;
        Quickshell.execDetached(["rm", "-f", root.fullImagePath, root.cropOutputPath, "/tmp/qs-debug.log"]);
    }

    function beginCapture(isUpload) {
        root.uploadMode = isUpload;
        displayImg.source = "";

        overlay.selX = 0;
        overlay.selY = 0;
        overlay.selW = 0;
        overlay.selH = 0;

        var screenName = root.getScreenName();
        if (screenName !== "") {
            captureProc.command = ["sh", "-c", "rm -f '" + root.fullImagePath + "' '" + root.cropOutputPath + "' /tmp/qs-debug.log && grim -o '" + screenName + "' - > " + root.fullImagePath];
        } else {
            captureProc.command = ["sh", "-c", "rm -f '" + root.fullImagePath + "' '" + root.cropOutputPath + "' /tmp/qs-debug.log && grim - > " + root.fullImagePath];
        }
        captureProc.running = true;
    }

    function cropAndProcess(x, y, w, h) {
        var imgW = displayImg.sourceSize.width;
        var scrW = root.getScreenWidth();

        var dpr = 1;
        if (imgW > 0 && scrW > 0)
            dpr = imgW / scrW;

        var sx = Math.round(x * dpr);
        var sy = Math.round(y * dpr);
        var sw = Math.round(w * dpr);
        var sh = Math.round(h * dpr);

        cropProc.command = ["sh", "-c", "magick " + root.fullImagePath + " -crop " + sw + "x" + sh + "+" + sx + "+" + sy + " " + root.cropOutputPath + " || convert " + root.fullImagePath + " -crop " + sw + "x" + sh + "+" + sx + "+" + sy + " " + root.cropOutputPath];
        cropProc.running = true;
    }

    Process {
        id: captureProc
        running: false
        command: []
        onExited: function (code) {
            if (code === 0) {
                displayImg.source = "file://" + root.fullImagePath;
                overlay.visible = true;
            } else {
                Quickshell.execDetached(["notify-send", "-i", "dialog-error", "Screenshot", "Capture failed (exit " + code + ")"]);
            }
        }
    }

    Process {
        id: cropProc
        running: false
        command: []
        onExited: function (code) {
            if (code !== 0) {
                Quickshell.execDetached(["notify-send", "-i", "dialog-error", "Screenshot", "Crop failed (exit " + code + ")"]);
                return;
            }
            Quickshell.execDetached(["rm", "-f", root.fullImagePath]);
            if (root.uploadMode)
                root.uploadScreenshot(root.cropOutputPath);
            else
                root.copyToClipboard(root.cropOutputPath);
        }
    }

    function copyToClipboard(filePath) {
        Quickshell.execDetached(["sh", "-c", "wl-copy --type image/png < " + filePath + " && notify-send -i '" + filePath + "' 'Screenshot' 'Copied to clipboard!'"]);
    }

    function uploadScreenshot(filePath) {
        var ts = new Date().toISOString().replace(/[:.]/g, "-").replace("T", "-").split(".")[0];
        uploadProc.command = ["sh", "-c", "curl -T '" + filePath + "' '" + uploadUrl + ts + ".png?pw=" + encodeURIComponent(uploadPassword) + "' | tail -n 1"];
        uploadProc.running = true;
    }

    Process {
        id: uploadProc
        running: false
        command: []
        stdout: StdioCollector {
            onStreamFinished: {
                var url = this.text.trim();
                if (url === "")
                    return;
                Quickshell.execDetached(["sh", "-c", "echo '" + url + "' | wl-copy && notify-send -i '" + root.cropOutputPath + "' 'Screenshot' 'Uploaded: " + url + "' && rm -f '" + root.cropOutputPath + "'"]);
            }
        }
    }

    IpcHandler {
        target: "screenshot"
        function screenshotToClipboard() {
            root.beginCapture(false);
        }
        function screenshotAndUpload() {
            root.beginCapture(true);
        }
    }
}
