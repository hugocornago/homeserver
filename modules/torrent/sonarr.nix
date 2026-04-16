{config, ...}: {
  services.sonarr = {
    enable = true;
    group = "storage";
  };

  services.bazarr = {
    enable = true;
    group = "storage";
  };
}
