{
  perSystem = { pkgs, ... }: {
    devshell = {
      pkgs = with pkgs; [
        nixd
      ];
    };
  };
}
