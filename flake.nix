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

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.3.0";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
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
    , lanzaboote
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
          lanzaboote.nixosModules.lanzaboote
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
}
