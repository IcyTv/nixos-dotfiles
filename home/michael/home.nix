{ inputs, lib, pkgs, ... }: {
  home = {
    username = "michael";
    homeDirectory = "/home/michael";
    stateVersion = "23.11";
  };

  programs = {
    home-manager.enable = true;
  };

  imports = [
    ./themes
    ./rice
    ./apps
    ./system
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
    overlays = [ 
      inputs.rust-overlay.overlays.default
      inputs.nur.overlay  
    ];
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  fonts.fontconfig.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  # profiles = builtins.attrNames programs.firefox.profiles;

  # TODO this is a hack and it's stupid to have this here....
  home.activation.enableFirefoxAddons = lib.hm.dag.entryAfter ["installPackages"] ''
    enable_addons_for_profile () {
      profile=$1

      if [ -f "$HOME"/.mozilla/firefox/$profile/extensions.json ]; then
        test=$(${lib.getExe pkgs.jq} -c '.addons[] |= if .type | test("extension") then .active |= true | .userDisabled |= false else . end' "$HOME"/.mozilla/firefox/$profile/extensions.json)
        # run echo "$test" ">" "$HOME/.mozilla/firefox/$profile/extensions.json"
        if [[ -v DRY_RUN ]]; then
          run echo "$test" ">" "$HOME/.mozilla/firefox/$profile/extensions.json"
        else
          echo "$test" > "$HOME/.mozilla/firefox/$profile/extensions.json"
        fi
      else
        echo "Invalid Profile $profile"
      fi
    }

  # TODO
    profiles="yes nixos"

    for profile in $profiles; do
      enable_addons_for_profile "$profile"
    done
  '';


}
