{ config, ... }:
{
  services.jackett = {
    enable = true;
    port = 9117;
  };
}
