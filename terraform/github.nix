{ config, ... }: {
  imports = [
    ./sops.nix
  ];

  terraform = {
    required_providers = {
      github = {
        source = "integrations/github";
      };
    };
  };

  provider = {
    github = {
      token = config.data.sops_file.secrets "data[\"github.token\"]";
    };
  };

  resource = {
    github_repository.embark-kubel = {
      name = "embark-kubel.el";
      description = "Embark target for kubel resources.";
      visibility = "public";
    };
  };
}
