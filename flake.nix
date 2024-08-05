{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    raspberry-pi-nix.url = "github:nix-community/raspberry-pi-nix";

  };

  outputs =
    { self, nixpkgs, home-manager, raspberry-pi-nix, ... }@inputs:
    let
      lib = nixpkgs.lib;
      system = "aarch64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      customOverlay = final: prev: { nix = pkgs.lix; };
    in {
      nixosConfigurations = {
        konrad-nixpi = lib.nixosSystem {
          specialArgs = { inherit inputs; };
          inherit system;
          modules = [
            { nixpkgs.overlays = [ customOverlay ]; }
            {
              nix.settings = {
                substituters = [ "https://nix-community.cachix.org" ];
                trusted-public-keys = [
                  "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
                ];
              };
              # Flakes
              nix.settings.experimental-features = [ "nix-command" "flakes" ];
            }
            {
              sdImage.compressImage = false;
              raspberry-pi-nix.board = "bcm2711";
              nix.settings.trusted-users = [ "@wheel" ];
            }
            ./configuration.nix
            ./home.nix
            raspberry-pi-nix.nixosModules.raspberry-pi
            home-manager.nixosModules.home-manager
          ];
        };
      };
    };

}
