#!/bin/sh

set -e

pushd ~/system-flake

git diff -U0 *.nix
git add .
sudo nixos-rebuild switch --flake $PWD
gen=$(nixos-rebuild list-generations | grep current | awk '{print $1}')
git commit -am "Generation $gen"
git push

popd