{
  inputs,
  pkgs,
  ...
}: let
  kde = pkgs.kdePackages or pkgs;
in {
  home.packages = [
    (pkgs.stdenv.mkDerivation {
      pname = "plasma6-applet-appgrid";
      version = "git";

      src = pkgs.fetchFromGitHub {
        owner = "xarbit";
        repo = "plasma6-applet-appgrid";
        rev = "40bb338c85b92a5b88b20d6ef060ddc2d211203e";
        sha256 = "0j1hin9h9sflcrbj6nzfz8189gl5m9mzfqlnws52zcw8n2440h6r";
      };

      nativeBuildInputs = [
        pkgs.cmake
        pkgs.extra-cmake-modules
        pkgs.gettext
        pkgs.pkg-config
        pkgs.qt6.wrapQtAppsHook
      ];

      buildInputs = [
        pkgs.qt6.qtbase
        pkgs.qt6.qtdeclarative

        kde.plasma-workspace
        kde.kservice
        kde.ki18n
        kde.kio
        kde.krunner
        kde.kwindowsystem
        kde.kcoreaddons
        kde.libplasma
        kde.kpackage
        kde.layer-shell-qt
      ];

      cmakeFlags = [
        "-DCMAKE_BUILD_TYPE=Release"
      ];
    })
  ];
}
