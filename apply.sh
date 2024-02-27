#!/bin/sh

set -e

pushd ~/system-flake

git diff

read -p "Continue (y/n)?" CONT
echo
if [[ ! "$CONT" =~ ^[Yy]$ ]]
then
    exit 1
fi

git add .
sudo nixos-rebuild switch --flake $PWD
gen=$(nixos-rebuild list-generations | grep current | awk '{print $1}')
git commit -am "Generation $gen"
git push

popd