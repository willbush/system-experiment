{
  description = "Experimenting with impermanence and wayland";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    impermanence.url = "github:nix-community/impermanence";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chemacs = {
      url = "github:plexus/chemacs2";
      flake = false;
    };
    crafted-emacs = {
      url = "github:SystemCrafters/crafted-emacs";
      flake = false;
    };
    # Not on melpa
    copilot-el = {
      url = "github:zerolfx/copilot.el";
      flake = false;
    };
  };

  outputs =
    inputs@{ nixpkgs
    , emacs-overlay
    , home-manager
    , impermanence
    , ...
    }: {
      nixosConfigurations = {
        blitzar = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          # Pass inputs into the NixOS module system
          specialArgs = { inherit inputs; };

          modules = [
            impermanence.nixosModules.impermanence
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.will = import ./home.nix;
            }
            {
              nixpkgs.overlays = [ emacs-overlay.overlay ];
            }
          ];
        };
      };
    };
}
