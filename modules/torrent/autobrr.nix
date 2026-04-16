{config, ...}: {
  sops.secrets.autobrr = {};
  services.autobrr = {
    enable = true;
    secretFile = config.sops.secrets.autobrr.path;
    settings = {
      port = 7474;
    };
  };
}
