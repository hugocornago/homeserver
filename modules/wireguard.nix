{ config, pkgs, ... }:
{
  sops.secrets.wg-private = {};
  sops.secrets.wg-preshared = {};

  networking.firewall.allowedUDPPorts = [ 51820 ];
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

  # setting up wireguard interface within network namespace
  systemd.services.wg = {
   description = "wg network interface";
   bindsTo = [ "netns@wg.service" ];
   requires = [ "network-online.target" ];
   after = [ "netns@wg.service" ];
   serviceConfig = {
     Type = "oneshot";
     RemainAfterExit = true;
     ExecStart = with pkgs; writers.writeBash "wg-up" ''
       set -ex
       ${iproute2}/bin/ip link add wg0 type wireguard
       ${iproute2}/bin/ip link set wg0 netns wg
       ${iproute2}/bin/ip -n wg address add 10.8.0.1/32 dev wg0
       # ${iproute2}/bin/ip -n wg -6 address add <ipv6 VPN addr/cidr> dev wg0
       ${iproute2}/bin/ip netns exec wg \
         ${wireguard-tools}/bin/wg set wg0 \
            listen-port 51820 \
            private-key ${config.sops.secrets.wg-private.path} \
            peer g28kfEFI+VG5mZEK84EQKJ86J8dSqSrjtiEGiLTbKkE= \
            preshared-key ${config.sops.secrets.wg-preshared.path} \
            endpoint 194.164.174.131:51820 \
            persistent-keepalive 15 \
            allowed-ips 0.0.0.0/0
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
