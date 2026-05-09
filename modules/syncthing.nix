{config, ...}: {
  networking.firewall.allowedTCPPorts = [8384];
  sops.secrets.syncthing-password = {};
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiPasswordFile = config.sops.secrets.syncthing-password.path;
    guiAddress = "0.0.0.0:8384";
    settings.devices = {
      laptop = {
        id = "Q3PGPXU-676NQNY-5KDJMQG-DYVJSYY-TEVS6XC-35WXJ7T-KFHNC7E-O6WVDAE";
        addresses = ["dynamic"];
      };
      desktop = {
        id = "PHZPZYQ-4TLAKNP-FJL44RM-E27Z7MV-CFWRXWT-DTBIPOV-35J2UFA-3O6M6QT";
        addresses = ["tcp://desktop.lan:51820" "dynamic"];
      };
      big-free-arm = {
        id = "NYLRYKD-7G7RJ77-7EEFZ5E-O5WKGKN-2FIGNUL-2IVDZHC-F7HJI52-Y2UUKQ2";
        addresses = ["tcp://1.1.1.1:51820"];
      };
    };
    settings.folders = {
      "Default" = {
        id = "default";
        path = "/storage/syncthing/Sync";
        devices = builtins.attrNames config.services.syncthing.settings.devices;
      };
      "University" = {
        path = "/storage/syncthing/uni";
        id = "grghq-etfgu";
        devices = builtins.attrNames config.services.syncthing.settings.devices;
      };
    };
  };
}
