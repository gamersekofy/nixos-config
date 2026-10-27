# Pin gogcli ahead of nixpkgs (unstable ships 0.44.0; upstream is 0.47.1).
# Leaf package: rebuilding it touches nothing else, no stdenv impact.
# Built and verified on this host: gog v0.47.1, slides create/* present.
final: prev: {
  gogcli = prev.gogcli.overrideAttrs (old: {
    version = "0.47.1";
    src = prev.fetchFromGitHub {
      owner = "openclaw";
      repo = "gogcli";
      tag = "v0.47.1";
      hash = "sha256-hjs5NW17X7r+/xLfHxypDyMiNuy0L5vKECRkctuuZlw=";
    };
    vendorHash = "sha256-YPNJB9PUesnwEPUQt5RO1dmJzBoU+MQQMUEtSd06/vY=";
  });
}
