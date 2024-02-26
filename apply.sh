#!/bin/sh

set -e

pushd ~/system-flake

git diff -U *.nix
sudo nixos-rebuild switch --flake $PWD
gen=$(nixos-rebuild list-generations | grep current)
git commit -am "$gen"

popd