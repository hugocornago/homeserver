{
  config,
  pkgs,
  ...
}: {
  sops.secrets = {
    deluge-auth.owner = "deluge";
  };

  services.deluge = {
    enable = true;
    web.enable = true;
    web.port = 8112;

    declarative = true;
    config = {
      download_location = "/storage/media/torrents";
      allow_remote = "true";
    };
    authFile = config.sops.secrets.deluge-auth.path;

    # allow access to /storage
    group = "storage";
  };

  # route traffic through wireguard
  systemd.services.deluged.bindsTo = ["netns@wg.service"];
  systemd.services.deluged.requires = ["network-online.target" "wg.service"];
  systemd.services.deluged.serviceConfig.NetworkNamespacePath = ["/var/run/netns/wg"];

  # allowing delugeweb to access deluged in network namespace, a socket is necesary
  systemd.sockets."proxy-to-deluged" = {
    enable = true;
    description = "Socket for Proxy to Deluge Daemon";
    listenStreams = ["58846"];
    wantedBy = ["sockets.target"];
  };

  # creating proxy service on socket, which forwards the same port from the root namespace to the isolated namespace
  systemd.services."proxy-to-deluged" = {
    enable = true;
    description = "Proxy to Deluge Daemon in Network Namespace";
    requires = ["deluged.service" "proxy-to-deluged.socket"];
    after = ["deluged.service" "proxy-to-deluged.socket"];
    unitConfig = {JoinsNamespaceOf = "deluged.service";};
    serviceConfig = {
      User = "deluge";
      Group = "storage";
      ExecStart = "${pkgs.systemd}/lib/systemd/systemd-socket-proxyd --exit-idle-time=5min 127.0.0.1:58846";
      PrivateNetwork = "yes";
    };
  };
}
