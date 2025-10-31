{ config, ... }:
{
  services.sonarr = {
    enable = true;
    group = "storage";
  };
}
