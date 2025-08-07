{
  terraform = {
    required_providers = {
      sops = {
        source = "carlpett/sops";
      };
    };
  };

  data = {
    sops_file = {
      secrets = {
        source_file = "secrets.enc.yaml";
      };
    };
  };
}
