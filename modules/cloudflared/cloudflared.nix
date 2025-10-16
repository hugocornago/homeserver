{ pkgs, config, inputs, ...}: {
  # quic-go udp buffer sizes
	boot.kernel.sysctl."net.core.rmem_max" = 7500000;
	boot.kernel.sysctl."net.core.wmem_max" = 7500000;

  services.cloudflared = {
    enable = true;
		package = pkgs.unstable.cloudflared;
		certificateFile = ./cert.pem;
    tunnels = {
      "df0bbc1a-2a17-4408-8dba-a843b0e59865" = {
        # ssh-homeserver
        credentialsFile = "${config.sops.secrets.cloudflared-ssh-homeserver-tunnel.path}";
				default = "http_status:404";
      };
    };
  };
}
