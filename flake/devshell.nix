{ lib, flake-parts-lib, ...  }: let
  inherit (lib) types;
  inherit (lib.options) mkOption;
in {
  options = {
    perSystem = flake-parts-lib.mkPerSystemOption
      ({ pkgs, config, ... }: let
        cfg = config.devshell;
      in {
        options.devshell = {
          pkgs = mkOption {
            type = types.listOf types.package;
            default = [
              pkgs.git-crypt
            ];
          };
        };

        config = {
          devShells = {
            default = pkgs.mkShell {
              buildInputs = cfg.pkgs;
            };
          };
        };
      });
  };
}
