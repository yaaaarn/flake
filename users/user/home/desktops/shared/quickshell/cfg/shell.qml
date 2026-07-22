//@ pragma UseQApplication
pragma ComponentBehavior: Bound
import Quickshell
import QtQuick

import "bar"
import "notifications"
import "wallpaper"
import "widgets"
import "vars" // qmllint disable import

ShellRoot {
    id: root

    Vars { id: vars } // qmllint disable import

    SystemPalette {
        id: activePalette
        colorGroup: SystemPalette.Active
    }

    Variants {
        model: Quickshell.screens

        Scope {
            id: scope
            property var modelData
            property bool controlCenterVisible: false

            WallpaperLayer {
                id: wallLayer
                screen: scope.modelData
                wallpaper: vars.wallpaper // qmllint disable missing-property
            }
            BlurredWallpaperLayer {
                screen: scope.modelData
                wallpaper: vars.wallpaper  // qmllint disable missing-property
            }
            CornerOverlay {
                screen: scope.modelData
            }
            Bar {
                screen: scope.modelData
            }
        }
    }

    NotificationDaemon {}
    ScreenshotTool {
        vars: vars
    }
}
