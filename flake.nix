{
  description = "IcyTv's NixOS system configuration";

  inputs = {
    # nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      # url = "github:nix-community/home-manager/release-23.11";
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/hyprland";
    xdg-portal-hyprland.url = "github:hyprwm/xdg-desktop-portal-hyprland";

    nix-colors.url = "github:misterio77/nix-colors";

    flake-parts.url = "github:hercules-ci/flake-parts";

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

    rust-overlay.url = "github:oxalica/rust-overlay";
    nur.url = github:nix-community/NUR;

    nyoom = {
      url = "github:ryanccn/nyoom";
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
    , lanzaboote
    , rust-overlay
    , nur
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
          nur.nixosModules.nur
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useUserPackages = true;
              useGlobalPkgs = false;
              verbose = true;
              backupFileExtension = "bak";
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
