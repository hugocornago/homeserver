{ config, pkgs, ... }:
{
  sops.secrets = {
    wg-private = {};
    wg-preshared = {};
    deluge-auth = {};
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

  # create a wg interface for deluge
  systemd.services."netns@" = {
   description = "%I network namespace";
   before = [ "network.target" ];
   serviceConfig = {
     Type = "oneshot";
     RemainAfterExit = true;
     ExecStart = "${pkgs.iproute2}/bin/ip netns add %I";
     ExecStop = "${pkgs.iproute2}/bin/ip netns del %I";
   };
  };

  systemd.services.wg = {
   description = "wg network interface";
   bindsTo = [ "netns@wg.service" ];
   requires = [ "network-online.target" ];
   after = [ "netns@wg.service" ];
   serviceConfig = {
     Type = "oneshot";
     RemainAfterExit = true;
     ExecStart = with pkgs; writers.writeBash "wg-up" ''
       set -e
       ${iproute2}/bin/ip link add wg0 type wireguard
       ${iproute2}/bin/ip link set wg0 netns wg
       ${iproute2}/bin/ip -n wg address add 10.8.0.1/32 dev wg0
       # ${iproute2}/bin/ip -n wg -6 address add <ipv6 VPN addr/cidr> dev wg0
       ${iproute2}/bin/ip netns exec wg \
         ${wireguard-tools}/bin/wg set wg0 \
              listen-port 51820 \
              private-key ${config.sops.secrets.wg-private.path} \
              preshared-key ${config.sops.secrets.wg-preshared.path} \
              peer g28kfEFI+VG5mZEK84EQKJ86J8dSqSrjtiEGiLTbKkE= \
              persistent-keepalive 15 \
              allowed-ips 0.0.0.0/0 \
              endpoint 194.164.174.131:51820
       ${iproute2}/bin/ip -n wg link set wg0 up
       # need to set lo up as network namespace is started with lo down
       ${iproute2}/bin/ip -n wg link set lo up
       ${iproute2}/bin/ip -n wg route add default dev wg0
       # ${iproute2}/bin/ip -n wg -6 route add default dev wg0
     '';
     ExecStop = with pkgs; writers.writeBash "wg-down" ''
       ${iproute2}/bin/ip -n wg route del default dev wg0
       # ${iproute2}/bin/ip -n wg -6 route del default dev wg0
       ${iproute2}/bin/ip -n wg link del wg0
     '';
   };
  };
}
