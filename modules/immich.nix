{...}:
{
  services.immich = {
    enable = true;
    port = 2283;
    group = "storage";
    mediaLocation = "/storage/photos";
  };
}
