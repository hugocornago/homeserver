{config, ...}: {
  services.suwayomi-server = {
    enable = true;
    group = "storage";
    dataDir = "/storage/media/manga";
    settings.server = {
      # Network
      ip = "127.0.0.1";
      port = 4577;
      debugLogsEnabled = true;

      # Authentication
      #basicAuthEnabled = true;
      #basicAuthUsername = "cornago";
      authMode = "none";

      # Updater
      autoDownloadNewChapters = true;
      autoDownloadNewChaptersLimit = 5;
      autoDownloadIgnoreReUploads = false;
      excludeUnreadChapters = true;
      excludeNotStarted = true;
      excludeCompleted = true;
      globalUpdateInterval = 12;
      updateMangas = true;

      # Compression
      downloadAsCbz = true;

      # Extensions
      extensionRepos = ["https://github.com/keiyoushi/extensions"];

      # flaresolverrr
      flareSolverrEnabled = true;
      flareSolverrUrl = "http://localhost:${toString config.services.flaresolverr.port}";
      flareSolverrTimeout = 60; # time in seconds
      flareSolverrSessionName = "suwayomi";
      flareSolverrSessionTtl = 15; # time in minutes
      flareSolverrAsResponseFallback = true;
    };
  };

  services.flaresolverr = {
    enable = true;
  };
}
