{config, ...}: {
  sops.secrets.cloudflare-token = {};

  systemd.services.ddclient.after = ["nss-user-lookup.target"];
  services.ddclient = {
    enable = true;
    interval = "5min";
    protocol = "cloudflare";
    passwordFile = "${config.sops.secrets.cloudflare-token.path}";
    domains = ["mqtt.cornago.net"];
    zone = "cornago.net";
    ssl = true;
  };
}
