{config, ...}: {
  sops.secrets = {
    mosquitto-robot-password = {};
    mosquitto-web-password = {};
  };

  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users.robot = {
          acl = [
            "write robot/data/#"
            "read robot/action/#"
          ];
          hashedPasswordFile = "${config.sops.secrets.mosquitto-robot-password.path}";
        };

        users.telegram = {
          acl = [
            "read robot/data/#"
            "write robot/action/#"
          ];
          hashedPasswordFile = "${config.sops.secrets.mosquitto-web-password.path}";
        };
      }
    ];
  };
}
