# { pkgs, ... }: let
#   src = pkgs.fetchFromGitHub {
#     owner = "null-dev";
#     rev = "0c4bf355f05c4cb9c0b740c1ddd4f2633300231e";
#     repo = "firefox-profile-switcher-connector";
#   }
# in {

# }

# { lib, fetchFromGitHub, pkgs, ... }:
# let
#   rustPlatform = pkgs.makeRustPlatform {
#     cargo = pkgs.rust-bin.stable.latest.minimal;
#     rustc = pkgs.rust-bin.stable.latest.minimal;
#   };
#   profileSwitcherPackage = rustPlatform.buildRustPackage rec {
#     pname = "firefox-profile-switcher-connector";

#     version = "v0.1.1";

#     src = pkgs.fetchFromGitHub {
#       owner = "null-dev";
#       rev = "v${version}";
#       repo = pname;
#       sha256 = "sha256-mnPpIJ+EQAjfjhrSSNTrvCqGbW0VMy8GHbLj39rR8r4=";
#     };

#     meta = with lib; {
#       description = "Native connector software for the 'Profile Switcher for Firefox' extension.";
#       homepage = "https://github.com/null-dev/firefox-profile-switcher-connector";
#       license = licenses.gpl3;
#     };

#     nativeBuildInputs = [ pkgs.cmake pkgs.pkg-config ];
#     buildInputs = [ pkgs.gtk3 ];

#     cargoSha256 = "sha256-QfeklKHsY3Ldutt954OxYk0PZxdACvmukrlzZFuI8vg=";

#     postInstall = ''
#     mkdir -p $out/lib/mozilla/native-messaging-hosts
#     sed -i s#/usr/bin/ff-pswitch-connector#$out/bin/firefox_profile_switcher_connector# manifest/manifest-linux.json
#     cp manifest/manifest-linux.json $out/lib/mozilla/native-messaging-hosts/ax.nd.profile_switcher_ff.json
#     '';
#   };
# in
# {
#   home.packages = [
#     profileSwitcherPackage
#   ];
# }

{ lib, pkgs, ... }:

pkgs.rustPlatform.buildRustPackage rec {
  pname = "firefox-profile-switcher-connector";
  version = "0.1.1";

  src = pkgs.fetchFromGitHub {
    owner = "null-dev";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-mnPpIJ+EQAjfjhrSSNTrvCqGbW0VMy8GHbLj39rR8r4=";
  };

  nativeBuildInputs = [ pkgs.cmake ];

  cargoSha256 = "sha256-EQIBeZwF9peiwpgZNfMmjvLv8NyhvVGUjVXgkf12Wig=";

  postInstall = ''
  mkdir -p $out/lib/mozilla/native-messaging-hosts
  sed -i s#/usr/bin/ff-pswitch-connector#$out/bin/firefox_profile_switcher_connector# manifest/manifest-linux.json
  cp manifest/manifest-linux.json $out/lib/mozilla/native-messaging-hosts/ax.nd.profile_switcher_ff.json
  '';

  meta = with lib; {
    description = "Native connector software for the 'Profile Switcher for Firefox' extension.";
    homepage = "https://github.com/null-dev/firefox-profile-switcher-connector";
    license = licenses.gpl3;
  };
}