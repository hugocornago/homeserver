{pkgs, ...}: {
  services.immich = {
    enable = true;
    package = pkgs.unstable.immich;
    port = 2283;
    group = "storage";
    mediaLocation = "/storage/photos";
  };
}
