{
  modulesPath,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./modules/neovim/neovim.nix
    ./modules/copyparty.nix
		./modules/cloudflare-ddns.nix
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
		allowedTCPPorts = [ 22 80 3923 ];
	};
  services.openssh.enable = true;

  environment.systemPackages = with pkgs; [
    curl
    git
    lazygit
		tmux
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINOHAzlWTCK89b4vehheZHX724HmclxzHnOq4RBEyF99 private"
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINUJ2JVXfDvpPgZ8qzL804oJB/pG71g6MdZt4jkYP2sO cloudflare"
  ];

  system.stateVersion = "25.05";
  nix.settings.experimental-features = ["nix-command" "flakes"];
}
