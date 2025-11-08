{pkgs,...}:
{
  systemd.services.bullen-ws = {
    enable = true;
    after = [ "network.target" ];
    description = "bullen websocket";
    serviceConfig = {
      Type = "exec";
      ExecStart = "${pkgs.bullen-server}/bin/bullen-websocket";
      Restart = "always";
    };
    environment = {
      RUST_LOG = "info";
    };
  };
}
