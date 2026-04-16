{config, ...}:
{
  sops.secrets = {
    mosquitto-robot-password = {};
    mosquitto-web-password = {};
  };

  services.mosquitto = {
    enable = true;
    logType = ["all"];
    listeners = [
      {
        users.test = {
          acl = [ 
            "read robot/data/#"
            "write robot/action/#"
          ];
          password = "testpassword";
        };

        users.robot = {
          acl = [
            "write robot/data/#"
            "read robot/action/#"
          ];
          password = "robotiscool";
          # hashedPasswordFile = "${config.sops.secrets.mosquitto-robot-password.path}";
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
