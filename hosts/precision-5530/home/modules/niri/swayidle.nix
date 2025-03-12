{pkgs, ...}: {
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock-effects}/bin/swaylock --clock --screenshot --effect-pixelate 50 --fade-in 3 --grace 5";
      }
    ];

    #systemdTarget = "graphical.target";

    timeouts = [
      {
        timeout = 10;
        command = "brightnessctl -s set 10";
        resumeCommand = "brightnessctl -r";
      }
      {
        timeout = 12;
        command = "systemctl suspend";
      }
    ];
  };
}
