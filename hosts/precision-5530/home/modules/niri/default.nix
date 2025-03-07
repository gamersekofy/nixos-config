{inputs, ...}: {
    imports = [
        inputs.niri.homeModules.niri
        ../../../../common/wm-utils/kitty.nix
    ];

    programs.niri = {
        settings = {
            binds = {

            };
        };
    };
}
