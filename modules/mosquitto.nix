{config, ...}:
{
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
            "read /robot/update_scripts"
            "read /robot/run_scripts"
            "write /robot/odometry_update"
            "write /robot/speed_update"
          ];
          hashedPasswordFile = "${config.sops.secrets.mosquitto-robot-password.path}";
        };

        users.web = {
          acl = [
            "write /robot/update_scripts"
            "write /robot/run_scripts"
            "read /robot/odometry_update"
            "read /robot/speed_update"
          ];
          hashedPasswordFile = "${config.sops.secrets.mosquitto-web-password.path}";
        };
      }
    ];
  };
}
