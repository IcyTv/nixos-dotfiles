#!/bin/sh

set -e

pushd ~/system-flake

git diff -U *.nix
sudo nixos-rebuild switch --flake $PWD
gen=$(nixos-rebuild list-generations | grep current | awk '{print $1}')
git commit -am "Generation $gen"

popd