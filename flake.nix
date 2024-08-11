{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";

  };

  outputs = { self, nixpkgs, home-manager, raspberry-pi-nix, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      customOverlay = final: prev: { nix = pkgs.lix; };

      home-manager = let
        src = nixpkgs.legacyPackages.${system}.applyPatches {
          name = "home-manager";
          src = inputs.home-manager;
          patches = nixpkgs.legacyPackages.${system}.fetchpatch {
            url =
              "https://patch-diff.githubusercontent.com/raw/nix-community/home-manager/pull/2548.patch";
            sha256 = "sha256-weI2sTxjEtQbdA76f3fahC9thiQbGSzOYQ7hwHvqt8s=";
          };
        };
      in nixpkgs.lib.fix
      (self: (import "${src}/flake.nix").outputs { inherit self nixpkgs; });
    in {
      nixosConfigurations = {
        konrad-nixpi = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          inherit system;
          modules = [
            {
              nixpkgs.overlays = [ customOverlay ];
              nixpkgs.config.allowUnfree = true;
            }
            {
              sdImage.compressImage = false;
              raspberry-pi-nix.board = "bcm2711";
            }
            ./configuration.nix
            ./nix-settings.nix
            {
              home-manager.backupFileExtension = "backupNix";
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.useUserService = true;
              home-manager.users.nixos = { imports = [ ./home.nix ]; };
            }
            raspberry-pi-nix.nixosModules.raspberry-pi
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };

}
