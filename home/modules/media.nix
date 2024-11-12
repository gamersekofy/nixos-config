{ pkgs, ... }: 
{
  home.packages = with pkgs; [
    nicotine-plus
  ];

  programs.mpv.enable = true;

  programs.obs-studio = {
    enable = true;
    plugins = with pkgs; [
      obs-studio-plugins.obs-pipewire-audio-capture
      obs-studio-plugins.obs-backgroundremoval
      obs-studio-plugins.input-overlay
      obs-studio-plugins.obs-vaapi
    ];
  };
}
