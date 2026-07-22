pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick
import QtQuick.Effects

PanelWindow { // qmllint disable uncreatable-type
    id: root
    required property var screen
    required property string wallpaper

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    WlrLayershell.namespace: "qs-blurred"

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    Rectangle {
        anchors.fill: parent
        clip: true

        Image {
            id: blurredSourceImage
            anchors.centerIn: parent
            width: parent.width + 64
            height: parent.height + 64
            source: root.wallpaper
            fillMode: Image.PreserveAspectCrop
            visible: false
            sourceSize.width: 480 * 2
            sourceSize.height: 270 * 2
            smooth: true
        }

        MultiEffect {
            width: blurredSourceImage.width
            height: blurredSourceImage.height
            anchors.centerIn: parent
            source: blurredSourceImage
            blurEnabled: true
            blurMax: 128
blur: 0.5
colorization: 0.25
contrast: 0.25
colorizationColor: "black"
        }
    }
}
