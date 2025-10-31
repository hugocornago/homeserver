{
  modulesPath,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./modules/neovim/neovim.nix
    ./modules/copyparty.nix
    ./modules/cloudflared/cloudflared.nix
    ./modules/cache.nix
    ./modules/wireguard.nix
    ./modules/torrent/deluge.nix
    ./modules/torrent/autobrr.nix
    ./modules/torrent/sonarr.nix
    ./modules/torrent/jackett.nix
    ./modules/jellyfin.nix
  ];

  environment.systemPackages = with pkgs; [
    curl
    git
    lazygit
    tmux
  ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    swraid.enable = true;
    swraid.mdadmConf = "PROGRAM ${pkgs.coreutils}/bin/true";
  };

  systemd.services."mdmonitor".environment = {
    MDADM_MONITOR_ARGS = "--scan --syslog";
  };

  networking.hostName = "server";
  networking.networkmanager.enable = true;
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [22 80 3923 9033];
  };
  services.openssh.enable = true;

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINOHAzlWTCK89b4vehheZHX724HmclxzHnOq4RBEyF99 private"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINUJ2JVXfDvpPgZ8qzL804oJB/pG71g6MdZt4jkYP2sO cloudflare"
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = "/root/.config/sops/age/keys.txt";

    # definition
    secrets.cloudflared-ssh-homeserver-tunnel = {};
  };

  system.stateVersion = "25.05";
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
