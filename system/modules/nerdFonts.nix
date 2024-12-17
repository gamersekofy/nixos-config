{ pkgs, ... }:
{
  fonts.packages = with pkgs; [
  	nerd-fonts.jetbrains-mono
	nerd-fonts.caskaydia-cove
	nerd-fonts._3270
  ];
}
