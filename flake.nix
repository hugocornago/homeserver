{
  description = "homeserver with NixOS!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly-overlay.inputs.nixpkgs.follows = "nixpkgs";
    copyparty.url = "github:9001/copyparty";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    copyparty,
    sops-nix,
    ...
  } @ inputs: let
    overlays = [
      inputs.neovim-nightly-overlay.overlays.default
      copyparty.overlays.default
    ];
  in {
    nixosConfigurations.homeserver = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        copyparty.nixosModules.default
        sops-nix.nixosModules.sops

        {
          nixpkgs.overlays = overlays;
        }

        ./disk-config.nix
        ./hardware-configuration.nix
        ./configuration.nix
      ];
      specialArgs = {
        inherit self inputs;
      };
    };
  };
}
