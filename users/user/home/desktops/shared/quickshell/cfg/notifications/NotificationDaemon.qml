pragma ComponentBehavior: Bound
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Wayland
import QtQuick

PanelWindow {
    id: root
    color: "transparent"
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.None
    WlrLayershell.exclusionMode: ExclusionMode.Ignore
    anchors {
        top: true
        bottom: true
        right: true
    }
    implicitWidth: 350 + 12 + 12
    visible: true

    property bool silent: false
    property bool popupInhibited: silent
    property int maxPopups: 6

    mask: Region {
        item: inputArea
    }

    Item {
        id: inputArea
        width: 350
        height: popupList.contentHeight
        anchors.right: parent.right
        anchors.rightMargin: 12
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 12
    }

    ListModel {
        id: notificationsModel
    }

    NotificationServer {
        actionsSupported: true
        bodyHyperlinksSupported: true
        bodyImagesSupported: true
        bodyMarkupSupported: true
        bodySupported: true
        imageSupported: true
        keepOnReload: false
        persistenceSupported: true

        onNotification: notification => {
            notification.tracked = true

            notification.closed.connect(() => {
                for (var i = 0; i < notificationsModel.count; i++) {
                    if (notificationsModel.get(i).nId === notification.id) {
                        notificationsModel.remove(i)
                        break
                    }
                }
            })

            notificationsModel.append({
                nId: notification.id,
                notification: notification
            })

            if (!root.popupInhibited) {
                var excess = notificationsModel.count - root.maxPopups
                while (excess > 0) {
                    notificationsModel.remove(0)
                    excess--
                }
            }
        }
    }

    ListView {
        id: popupList
        width: 350
        anchors {
            right: parent.right
            rightMargin: 12
            bottom: parent.bottom
            bottomMargin: 12
            top: parent.top
        }
        spacing: 8
        verticalLayoutDirection: ListView.BottomToTop
        interactive: false
        model: notificationsModel
        clip: true

        add: Transition {
            ParallelAnimation {
                NumberAnimation { property: "opacity"; from: 0.0; to: 1.0; duration: 200 }
                NumberAnimation { property: "x"; from: 358; to: 0; duration: 300; easing.type: Easing.OutCubic }
            }
        }
        remove: Transition {
            NumberAnimation { property: "opacity"; to: 0.0; duration: 200 }
            NumberAnimation { property: "x"; to: 358; duration: 250; easing.type: Easing.InCubic }
        }
        addDisplaced: Transition {
            ParallelAnimation {
                NumberAnimation { property: "y"; duration: 300; easing.type: Easing.OutCubic }
                NumberAnimation { property: "opacity"; to: 1.0; duration: 150 }
            }
        }
        removeDisplaced: Transition {
            NumberAnimation { property: "y"; duration: 300; easing.type: Easing.OutCubic }
        }

        delegate: NotificationPopup {
            required property var modelData
            notification: modelData.notification
        }
    }
}
