{ lib
, stdenv
, fetchFromGitHub
, qt5
, wrapQtAppsHook
, pkgs ? import <nixpkgs>
}:

stdenv.mkDerivation rec {
  pname = "whatsie";
  version = "4.14.2";

  nativeBuildInputs = [
    wrapQtAppsHook
    pkgs.git
    pkgs.icu
    pkgs.icu.dev
  ];

  buildInputs = [
    pkgs.icu
    pkgs.icu.dev
    qt5.full
  ];

  src = fetchFromGitHub {
    owner = "keshavbhatt";
    repo = "whatsie";
    rev = "v${version}";
    sha256 = "sha256-VArG3vFR7KkuMbFpk+jZHLNa8Js83IvmRHh+M6tSmi0=";
  };

  sourceRoot = "${src.name}/src";

  meta = with lib; {
    license = licenses.mit;
  };

  configureScript = "qmake";
  dontAddPrefix = true;


  passthru = {
    qtIcuDataDir = pkgs.icu.out;  # Pass ICU data directory to the build
  };

  # configureFlags =[ "-project" ];
}
