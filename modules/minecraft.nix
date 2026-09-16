{pkgs, ...}: {
  virtualisation.docker.enable = true;
  networking.firewall.allowedTCPPorts = [25565 20000];
  networking.firewall.allowedUDPPorts = [24454];

  services.minecraft-servers = {
    enable = false;
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

    servers.iki = {
      enable = false;
      jvmOpts = "-Xms6144M -Xmx8192M";
      # autoStart = true;
      enableReload = true;
      openFirewall = true;
      # restart = "always";

      operators."Cornagooo" = "0321dd7e-f49d-4f97-a304-3d056159cda8";

      # allow cracked versions
      serverProperties.online-mode = false;
      serverProperties.motd = "Servidor de iki.";
      serverProperties.server-port = 20000;

      package = pkgs.paperServers.paper-1_21_11;

      files.plugins = pkgs.linkFarmFromDrvs "plugins" (builtins.attrValues {
        AdvancedBackups = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/Jrmoreqs/versions/kLUZZ2KH/AdvancedBackups-spigot-1.21-3.7.1.jar";
          sha256 = "sha256-JCR7RfWUU9Ur71b1ErzzSEX1QE9GeEZ6i4snA43HPIs=";
        };
        LibreLogin = pkgs.fetchurl {
          url = "https://cdn.modrinth.com/data/tL0SCXYq/versions/reFUiAdB/LibreLogin.jar";
          sha256 = "sha256-PfhI1AWOY/N8+f6ZdUL9SchDdEQNEWo0rEBSJ4qnfk8=";
        };
      });
    };
  };
}
