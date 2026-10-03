{config, ...}: {
  networking.firewall.allowedTCPPorts = [8384 22067 22070];
  sops.secrets.syncthing-password = {};
  services.syncthing = {
    enable = true;
    group = "storage";
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    settings.gui.insecureAdminAccess = true;
    settings.devices = {
      laptop = {
        id = "HPSSPX2-K4ELNWZ-LV7Y7DU-WLTI3KZ-F6SP626-Q6DXKS3-ATRGHUM-RFX6MAT";
        addresses = ["dynamic"];
      };
      desktop = {
        id = "HSFKSZZ-XICCJXX-KILDD5N-UI7WRKX-4E2RIGK-DVBH777-QGFRV5A-BTYWJA6";
        addresses = ["dynamic"];
      };
      # big-free-arm = {
      #   id = "NYLRYKD-7G7RJ77-7EEFZ5E-O5WKGKN-2FIGNUL-2IVDZHC-F7HJI52-Y2UUKQ2";
      #   addresses = ["tcp://1.1.1.1:51820"];
      # };
    };
    settings.folders = {
      "Default" = {
        id = "general";
        path = "/storage/syncthing/Sync";
        devices = builtins.attrNames config.services.syncthing.settings.devices;
        ignorePerms = true;
      };
      "University" = {
        path = "/storage/syncthing/uni";
        id = "uni";
        devices = builtins.attrNames config.services.syncthing.settings.devices;
        ignorePerms = true;
      };
    };
  };

  services.syncthing.relay = {
    enable = true;
    providedBy = "Cornago's Private Relay.";
    pools = [];
    port = 22067;
    statusPort = 22070;
  };
}
