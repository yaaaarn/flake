pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow { // qmllint disable uncreatable-type
    id: root

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    color: "transparent"

    readonly property real cornerRadius: 16
    readonly property color cornerColor: "black"

    mask: Region {
        Region {
            x: 0
            y: 0
            width: root.cornerRadius
            height: root.cornerRadius
        }
        Region {
            x: root.width - root.cornerRadius
            y: 0
            width: root.cornerRadius
            height: root.cornerRadius
        }
        Region {
            x: root.width - root.cornerRadius
            y: root.height - root.cornerRadius
            width: root.cornerRadius
            height: root.cornerRadius
        }
        Region {
            x: 0
            y: root.height - root.cornerRadius
            width: root.cornerRadius
            height: root.cornerRadius
        }
    }

    Canvas {
        width: root.width
        height: root.height

        onPaint: {
            var ctx = getContext("2d");
            ctx.reset();
            ctx.fillStyle = root.cornerColor;

            var w = width;
            var h = height;
            var r = root.cornerRadius;

            ctx.beginPath();
            ctx.moveTo(0, 0);
            ctx.lineTo(r, 0);
            ctx.arc(r, r, r, -Math.PI / 2, -Math.PI, true);
            ctx.lineTo(0, 0);
            ctx.moveTo(w, 0);
            ctx.lineTo(w, r);
            ctx.arc(w - r, r, r, 0, -Math.PI / 2, true);
            ctx.lineTo(w, 0);
            ctx.moveTo(w, h);
            ctx.lineTo(w - r, h);
            ctx.arc(w - r, h - r, r, Math.PI / 2, 0, true);
            ctx.lineTo(w, h);
            ctx.moveTo(0, h);
            ctx.lineTo(0, h - r);
            ctx.arc(r, h - r, r, Math.PI, Math.PI / 2, true);
            ctx.lineTo(0, h);
            ctx.fill();
        }
    }
}
