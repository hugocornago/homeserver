{...}: {
  # cloudflared service install eyJhIjoiZDdjZTlkMzM5NDUxY2Y4MDJjNGE3YTc3MzFmNjA5OWMiLCJ0IjoiMjMzZjZlMTAtMzdjMS00ZDIxLWEyMDItY2U4NWFkMGI0Zjk3IiwicyI6Ik1qWTVaamt4TmpZdFlUY3lPQzAwWTJSbExXRXlNR1V0Wm1SaU5EazBaVFV6Tm1aayJ9
  services.cloudflared = {
    enable = true;
    tunnels = {
      "233f6e10-37c1-4d21-a202-ce85ad0b4f97" = {
        # ssh-homeserver
        credentialsFile = "${config.sops.secrets.cloudflared-ssh-homeserver-tunnel.path}";
      };
    };
  };
}
