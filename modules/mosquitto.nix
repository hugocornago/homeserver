{config, ...}:
{
  sops.secrets.mosquitto-password = {};
  services.mosquitto = {
    enable = true;
    listeners = [
      {
        users.robot = {
          acl = [
            "readwrite #"
          ];
          hashedPasswordFile = "${config.sops.secrets.mosquitto-password.path}";
        };
        settings = {
          protocol = "websockets";
        };
      }
    ];
  };
}
