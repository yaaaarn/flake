{ pkgs, ... }: {
  services.tangle = {
    enable = true;
    actions = [
      {
        trigger_on_state = "Charging";
        threshold_percentage = 0;
        operator = "any";
        command = [
          "${pkgs.libnotify}/bin/notify-send"
          "--urgency=low"
          "--icon=battery-charging"
          "(=^•ω•^=)♡"
          "plugged in at {percent}%! charging now, nya~ ♡"
        ];
      }
      {
        trigger_on_state = "Discharging";
        threshold_percentage = 0;
        operator = "any";
        command = [
          "${pkgs.libnotify}/bin/notify-send"
          "--urgency=normal"
          "--icon=battery"
          "(=^-ω-^=)"
          "unplugged at {percent}%. running on battery, nya~"
        ];
      }
      {
        trigger_on_state = "Full";
        threshold_percentage = 95;
        operator = ">=";
        command = [
          "${pkgs.libnotify}/bin/notify-send"
          "--urgency=low"
          "--icon=battery-full"
          "(=^▽^=)★"
          "battery is full ({percent}%)! you can unplug now, nya~ ★"
        ];
      }
      {
        trigger_on_state = "Discharging";
        threshold_percentage = 20;
        operator = "<=";
        command = [
          "${pkgs.libnotify}/bin/notify-send"
          "--urgency=normal"
          "--icon=battery-low"
          "(=；ω；=)"
          "battery getting low: {percent}%... please fill me up senpai~ nya"
        ];
      }
      {
        trigger_on_state = "Discharging";
        threshold_percentage = 10;
        operator = "<=";
        command = [
          "${pkgs.libnotify}/bin/notify-send"
          "--urgency=critical"
          "--icon=battery-caution"
          "(=；Д；=)!!"
          "VERY LOW BATTERY: {percent}%!! PLEASE FUCKING PUT IT IN ME!!"
        ];
      }
    ];
  };

}
