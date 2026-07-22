pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.UPower
import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root
    visible: UPower.displayDevice.isLaptopBattery
    color: "#000000"
    radius: 16
    Layout.alignment: Qt.AlignHCenter
    implicitWidth: 32
    implicitHeight: 32

    Image {
        anchors.centerIn: parent
        width: 16
        height: 16
        sourceSize.width: this.width
        sourceSize.height: this.height
        source: Quickshell.iconPath(UPower.displayDevice.iconName)
    }
}
