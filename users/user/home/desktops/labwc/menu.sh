#!/bin/sh

printf '%b\n' '
<openbox_pipe_menu>

  <item label="Web Browser" name.action="Execute" command.action="firefox" icon="firefox" />
  <item label="Terminal" name.action="Execute" command.action="foot" icon="utilities-terminal" />
  <item label="File Manager" name.action="Execute" command.action="pcmanfm" icon="system-file-manager" />

  <separator />'

labwc-menu-generator -b -I -t foot

printf '%b\n' '
  <separator />

  <menu id="help" label="Help" icon="help">
    <separator label="Online Help" />
    <item label="labwc.github.io" name.action="Execute" command.action="firefox https://labwc.github.io" icon="applications-development-web" />

    <separator label="Man Pages" />
    <item label="labwc(1)" name.action="Execute" command.action="firefox https://labwc.github.io/labwc.1.html" icon="deepin-manual" />
    <item label="labwc-config(5)" name.action="Execute" command.action="firefox https://labwc.github.io/labwc-config.5.html" icon="deepin-manual" />
    <item label="labwc-theme(5)" name.action="Execute" command.action="firefox https://labwc.github.io/labwc-theme.5.html" icon="deepin-manual" />
    <item label="labwc-menu(5)" name.action="Execute" command.action="firefox https://labwc.github.io/labwc-menu.5.html" icon="deepin-manual" />
    <item label="labwc-actions(5)" name.action="Execute" command.action="firefox https://labwc.github.io/labwc-actions.5.html" icon="deepin-manual" />
    <item label="labnag(1)" name.action="Execute" command.action="firefox https://labwc.github.io/labnag.1.html" icon="deepin-manual" />
  </menu>

  <menu id="Preferences" label="Preferences" icon="applications-engineering">
    <item label="Edit rc.xml" name.action="Execute" command.action="featherpad ~/.config/labwc/rc.xml" icon="text-x-generic" />
    <item label="Edit autostart" name.action="Execute" command.action="featherpad ~/.config/labwc/autostart" icon="text-x-generic" />
  </menu>

  <menu id="Exit" label="Exit" icon="application-exit">
    <item label="Reconfigure" name.action="Reconfigure" icon="labwc" />
    <item label="Logout" name.action="Exit" icon="application-exit" />
  </menu>

</openbox_pipe_menu>'
