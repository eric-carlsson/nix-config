{
  description = "Your new nix config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager/release-24.05";
  };

  outputs = {
    nixpkgs,
    home-manager,
    ...
  }: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.alejandra;

    nixosConfigurations = {
      hades = nixpkgs.lib.nixosSystem {
        modules = [
          ./hosts/hades/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.users.eric = import ./hosts/hades/home.nix;
          }
        ];
      };
    };
  };
}