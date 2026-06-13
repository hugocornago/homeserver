{...}: {
  services.portainer = {
    enable = true;
    openFirewall = false;
    port = 9443;
  };
}
