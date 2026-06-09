{pkgs, ...}: {
  virtualisation.docker.enable = true;

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;
    servers.bambino = {
      enable = true;
      jvmOpts = "-Xms6144M -Xmx8192M";
      autoStart = true;
      enableReload = true;
      restart = "always";

      operators.cornagooo = "0321dd7e-f49d-4f97-a304-3d056159cda8";

      # allow cracked versions
      serverProperties.online-mode = false;
      serverProperties.motd = "Servidor de cornago.";

      package = pkgs.vanillaServers.vanilla;
    };
  };
}
