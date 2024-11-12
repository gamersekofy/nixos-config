 { pkgs, ... }: 
 {
 	home.packages = with pkgs; [
		firefox-bin
		microsoft-edge
	];
 }
