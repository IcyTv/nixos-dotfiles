#!/bin/sh

set -e

pushd ~/system-flake

git diff HEAD

read -p "Continue (y/n)?" CONT
if [[ ! "$CONT" =~ ^[Yy]$ ]]
then
    exit 1
fi

git add .
sudo nixos-rebuild switch --flake $PWD
nix run .#home-manager -- switch --flake .#michael
gen=$(nixos-rebuild list-generations | grep current | awk '{print $1}')
git commit -am "Generation $gen"
git commit --amend

# git push

popd