{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    # Pop-shell for GNOME 42
    nixpkgs-e49db01.url = "github:nixos/nixpkgs/e49db01d2069ef3ed78d557c6ad6bd426b86d806";

    # Azure CLI 2.62
    nixpkgs-e081643.url = "github:nixos/nixpkgs/e0816431a23a06692d86c0b545b4522b9a9bc939";

    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixvim.url = "github:nix-community/nixvim/nixos-24.05";
    nixvim.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixvim,
    ...
  } @ inputs: let
    inherit (self) outputs;

    system = "x86_64-linux";

    sharedNixpkgsConfig = {
      nixpkgs = {
        config.allowUnfree = true;
        overlays = builtins.attrValues outputs.overlays.shared;
      };
    };
  in {
    formatter.${system} = nixpkgs.legacyPackages.${system}.alejandra;

    overlays = import ./overlays {inherit inputs;};

    packages.${system} = import ./pkgs nixpkgs.legacyPackages.${system};

    nixosConfigurations = {
      hades = nixpkgs.lib.nixosSystem {
        modules = [
          sharedNixpkgsConfig
          ./hosts/hades/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              sharedModules = [
                nixvim.homeManagerModules.nixvim
              ];
              users.eric = import ./hosts/hades/home.nix;
            };
          }
        ];
      };
    };

    homeConfigurations = {
      "ecarls18@5CG2149Z4L" = home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [
          sharedNixpkgsConfig
          {nixpkgs.overlays = builtins.attrValues outputs.overlays.gnome42;}
          nixvim.homeManagerModules.nixvim
          ./hosts/5CG2149Z4L/home.nix
        ];
      };
    };
  };
}
