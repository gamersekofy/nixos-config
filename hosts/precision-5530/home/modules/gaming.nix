{pkgs, ...}: {
  home.packages = with pkgs; [
    heroic
    mangohud
    osu-lazer-bin
      (prismlauncher.override {
    # Add binary required by some mod
    additionalPrograms = [ ffmpeg ];

    # Change Java runtimes available to Prism Launcher
    jdks = [
      graalvm-ce
      zulu8
      zulu17
      zulu
    ];
  })
  ];
}
