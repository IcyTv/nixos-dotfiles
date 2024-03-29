
{ inputs, lib, config, pkgs, lanzaboote, ... }: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix

    # Import your generated (nixos-generate-config) hardware configuration
    # ./hardware-configuration.nix

    # options username, hostname 
    ../modules/username.nix
    ../modules/audio.nix
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  nixpkgs.config.allowUnfree = true;

  nix = {
    # This will add each flake input as a registry
    # To make nix3 commands consistent with your flake
    registry = lib.mapAttrs (_: value: { flake = value; }) inputs;

    # This will additionally add your inputs to the system's legacy channels
    # Making legacy nix commands consistent as well, awesome!
    nixPath = lib.mapAttrsToList (key: value: "${key}=${value.to.path}")
      config.nix.registry;

    settings = {
      # Enable flakes and new 'nix' command
      experimental-features = "nix-command flakes";
      # Deduplicate and optimize nix store
      auto-optimise-store = true;
      keep-outputs = true;
      keep-derivations = true;
      allow-import-from-derivation = true;
      trusted-users = [ "root" ];
      # Binary Cache
      trusted-public-keys = [
        "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "iohk.cachix.org-1:DpRUyj7h7V830dp/i6Nti+NEO2/nhblbov/8MW7Rqoo="
        "cache.iog.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      ];
      substituters = [
        "https://cache.iog.io"
        "https://cache.nixos.org"
        "https://iohk.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://cache.garnix.io"
      ];
    };
  };

  boot = {
    # be able to mount windows
    supportedFilesystems = [ "ntfs" ];
    # Bootloader.
    loader = {
      systemd-boot.enable = lib.mkForce false;
      systemd-boot.configurationLimit = 3;
      systemd-boot.editor = false;

      efi.canTouchEfiVariables = true;
      # boot immedietely into latest generation. To bypass press shift while booting into systemd
      # timeout = 0;
    };
    # https://discourse.nixos.org/t/easy-refind-boot-by-booting-into-systemd-boot-from-refind/28507/5?u=zmrocze
    # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  
    lanzaboote = {
      enable = true;
      pkiBundle = "/etc/secureboot";
      settings = {
        beep = true;
        default = "@saved";
        timeout = 10;
      };
    };

    kernelParams = [
      "btusb.enable_autosuspend=n"
    ];
  };

  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking = {
    networkmanager.enable = true;
    hostName = "${config.hostname}";
    # for spotify
    firewall.enable = true;
    firewall.allowedTCPPorts = [ 57621 ];

    # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
    # (the default) this is the recommended approach. When using systemd-networkd it's
    # still possible to use this option, but it's recommended to use it in conjunction
    # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
    useDHCP = lib.mkDefault true;
    # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
    # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;
  };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
  };

  services = {
    # Enable the X11 windowing system.
    xserver = {
      enable = true;

      # Enable the GNOME Desktop Environment.
      displayManager = {
        defaultSession = "hyprland";

        autoLogin = {
          enable = true;
          user = "${config.username}";
        };

        gdm = {
          enable = true;
          wayland = true;
        };
      };
      # Configure keymap in X11
      xkb = {
        layout = "us";
        variant = "altgr-intl";
      };
    };

    printing.enable = true;
    flatpak.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # This setups a SSH server. Very important if you're setting up a headless system.
    # Feel free to remove if you don't need it.
    openssh = {
      enable = false;
      # Forbid root login through SSH.
      # PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      # passwordAuthentication = false;
    
      settings = {
        PermitRootLogin = "no";
      };
    };

    getty = {
      autologinUser = "michael";
    };

    # services.flatpak.enable = true;
    # services.accounts-daemon.enable = true;

    locate = {
      enable = true;
      package = pkgs.plocate;
      interval = "hourly";
      localuser = null;

      prunePaths = [
        "/mnt/windows" # Don't search windows partition (for now)

        # Default exclusion paths
        "/tmp"
        "/var/tmp"
        "/var/cache"
        "/var/lock"
        "/var/run"
        "/var/spool"
        "/nix/store"
        "/nix/var/log/nix"
      ];
    };

  };

  environment = {
    etc."xdg/user-dirs.defaults".source = etc/user-dirs.defaults;

    variables.EDITOR = "nvim";
    sessionVariables.NIXOS_OZONE_WL = "1";

    # this enabled `$ man alias`
    systemPackages = with pkgs; [ 
      man-pages
      man-pages-posix 
      git 
      neovim 
      sbctl
      inputs.xdg-portal-hyprland.packages.x86_64-linux.xdg-desktop-portal-hyprland  
      openrgb
    ];
  };

  # this no clue what it does
  documentation.dev.enable = true;

  programs = {
    # somehow this is needed here as well as home.nix,
    # https://www.reddit.com/r/NixOS/comments/z16mt8/cant_seem_to_set_default_shell_using_homemanager/
    zsh.enable = true;

    dconf.enable = true;

    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
  };

  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      (pkgs.xdg-desktop-portal-gtk.override {
        # Do not build portals that we already have.
        buildPortalsInGnome = false;
      })
    ];
  };

  systemd.user.services.xdg-desktop-portal-gtk = {
    wantedBy = [ "xdg-desktop-portal.service" ];
    before = [ "xdg-desktop-portal.service" ];
  };

  # security.doas.enable = true;
  # security.sudo.enable = false;
  # security.doas.extraConfig = builtins.readFile ./doas.conf;

  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}