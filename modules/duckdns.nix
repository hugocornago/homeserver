{pkgs, ...}: let
  token = pkgs.writeText "1c93691a-bb9b-4333-82c7-13d107404b70";
in {
  services.duckdns = {
    enable = true;
    domains = ["cornago"];
    tokenFile = token;
  };
}
