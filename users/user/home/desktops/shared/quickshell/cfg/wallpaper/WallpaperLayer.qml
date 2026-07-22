pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow { // qmllint disable uncreatable-type
    id: root
    required property var screen
    required property string wallpaper

    // --- THE FIX: Expose the inner visual item ---
    property alias contentItem: wallpaperImage

    WlrLayershell.layer: WlrLayer.Background
    WlrLayershell.exclusionMode: ExclusionMode.Ignore

    anchors.top: true
    anchors.bottom: true
    anchors.left: true
    anchors.right: true

    Image {
        id: wallpaperImage // Added ID here
        anchors.fill: parent
        source: root.wallpaper
        fillMode: Image.PreserveAspectCrop
    }
}
