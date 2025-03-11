{
   services.swayidle = {
      events = [
         {
	    event = "before-sleep";
	    command = "swaylock --clock --screenshot --effect-pixelate 50 --fade-in 3 --grace 5";
	 }
      ];

      systemdTarget = "graphical.target";

      timeouts = [
         {
	    timeout = 90;
	    command = "brightnessctl -s set 10";
	    resumeCommand = "brightnessctl -r";
	 }
	 {
	    timeout = 120;
	    command = "systemctl suspend";
	 }
      ];
   };
}
