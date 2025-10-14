{
  modulesPath,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./modules/neovim/neovim.nix
    ./modules/copyparty.nix
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
  networking.firewall.enable = false;
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    lazygit
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINOHAzlWTCK89b4vehheZHX724HmclxzHnOq4RBEyF99 private"
  ];

	users.groups.storage.gid = 999;

  system.stateVersion = "25.05";
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
