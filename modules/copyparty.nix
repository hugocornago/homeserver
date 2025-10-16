{config, ...}: {
  # create custom user and group for copyparty
  users.groups.storage = {};
  users.users.copyparty = {
    name = "copyparty";
    group = "storage";
    isSystemUser = true;
  };

  system.activationScripts.mountstorage = {
    text = ''
      #!/bin/sh
      mkdir -p /storage
      chown -R root:storage /storage
    '';
  };

  sops.secrets.copyparty-password.owner = "copyparty";

  services.copyparty = {
    enable = true;
    user = "copyparty";
    group = "storage";

    # global settings
    settings = {
      # network
      i = "0.0.0.0";
      p = [3923];

      # cores
      j = 0; # auto
      no-reload = true;
      qr = false;
    };

    # create users
    accounts = {
      cornago.passwordFile = "${config.sops.secrets.copyparty-password.path}";
    };

    # create a volume
    volumes = {
      "/" = {
        path = "/storage";
        access = {
          A = ["cornago"];
        };
        # see `copyparty --help-flags` for available options
        flags = {
          # "fk" enables filekeys (necessary for upget permission) (4 chars long)
          fk = 4;
          # scan for new files every 60sec
          scan = 20;
          # volflag "e2d" enables the uploads database
          e2d = true;
          # "d2t" disables multimedia parsers (in case the uploads are malicious)
          d2t = true;
          # skips hashing file contents if path matches *.iso
          nohash = "\.iso$";
        };
      };
    };
  };
}
