{
  description = "IcyTv's NixOS system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/hyprland";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";

    nix-colors.url = "github:misterio77/nix-colors";

    flake-parts.url = "github:hercules-ci/flake-parts";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    manix = {
      url = "github:nix-community/manix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { self
    , nixpkgs
    , hyprland
    , home-manager
    , nix-colors
    , flake-parts
    , spicetify-nix
    , ...
    }@inputs: {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit
            inputs
            hyprland
            spicetify-nix
            nix-colors
            ;
        };

        modules = [
          ./hosts/nixos.nix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = false;
              extraSpecialArgs = { inherit inputs spicetify-nix nix-colors; };
              users.michael = ./home/michael/home.nix;
            };
          }
          hyprland.nixosModules.default
          { programs.hyprland.enable = true; }
        ];
      };
    };

  # outputs =
  #   { self
  #   , nixpkgs
  #   , hyprland
  #   , home-manager
  #   , nix-colors
  #   , flake-parts
  #   , spicetify-nix
  #   , ...
  #   }@inputs:
  #   let
  #     system = "x86_64-linux";
  #     hostname = "nixos";
  #     username = "michael";
  #     pkgsFor = system:
  #       import inputs.nixpkgs {
  #         inherit system;
  #         config = {
  #           permittedInsecurePackages = [ "electron-25.9.0" ];
  #           allowUnfree = true;
  #           allowUnfreePredicate = _: true;
  #         };
  #       };
  #   in
  #   flake-parts.lib.mkFlake { inherit inputs; } rec {
  #     systems = [ system ];
  #     perSystem = { config, pkgs, system, ... }: {
  #       _module.args.pkgs = pkgsFor system;
  #     };

  #     flake = {
  #       nixosConfigurations = {
  #         "nixos" = inputs.nixpkgs.lib.nixosSystem {
  #           specialArgs = {
  #             inherit
  #               inputs
  #               hyprland
  #               spicetify-nix
  #               nix-colors
  #               ;
  #             mypkgs = pkgsFor system;
  #           };
  #           modules = [ ./hosts/nixos.nix ];
  #         };
  #       };

  #       homeConfigurations = {
  #         "${username}@${hostname}" =
  #           home-manager.lib.homeManagerConfiguration {
  #             pkgs = pkgsFor system;
  #             extraSpecialArgs = { inherit inputs spicetify-nix nix-colors username; };
  #             modules = [ (import ./home/${username}/home.nix) ];
  #           };
  #       };
  #     };
  #   };
}
