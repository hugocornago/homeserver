{ config, ... }:
{
  services.jellyfin = {
    enable = true;
    group = "storage";
  };
}
