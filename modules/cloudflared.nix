{ config, ...}: {
  # quic-go udp buffer sizes
	boot.kernel.sysctl."net.core.rmem_max" = 7500000;
	boot.kernel.sysctl."net.core.wmem_max" = 7500000;

  services.cloudflared = {
    enable = true;
    tunnels = {
      "233f6e10-37c1-4d21-a202-ce85ad0b4f97" = {
        # ssh-homeserver
        credentialsFile = "${config.sops.secrets.cloudflared-ssh-homeserver-tunnel.path}";
				default = "http_status:404";
      };
    };
  };
}
