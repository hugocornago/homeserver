{config, ...}: {
  sops.secrets.autobrr = {};
  services.autobrr = {
    enable = false;
    secretFile = config.sops.secrets.autobrr.path;
    settings = {
      port = 7474;
    };
  };
}
