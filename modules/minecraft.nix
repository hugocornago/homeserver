{ pkgs, ... }:
{

  services.minecraft-servers = {
    enable = true;
    eula = true;
    openFirewall = true;

    servers.bambino = {
      enable = true;
      autoStart = true;
      package = pkgs.minecraft-server;
      jvmOpts = "-Xms10G -Xmx10G -XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:InitiatingHeapOccupancyPercent=15 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true";

      operators.Cornagooo = "9410c450-9333-39f9-8e58-a3424f4bdf3f";

      serverProperties = {
        online-mode = false;
        max-players = 25;

        enable-rcon = true;
        "rcon.password" = "mc";

        difficulty = "normal";
        motd = "A Minecraft Server";
      };
    };
  };
}
