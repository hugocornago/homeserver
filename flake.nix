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
  };

  outputs = {
    self,
    nixpkgs,
    disko,
    ...
  }@inputs: {
    nixosConfigurations.homeserver = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
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
