#!/usr/bin/env bash

HOST=$(hostname)
if [ -e ~/nix-config ]; then
    all_cores=$(sysctl -n hw.logicalcpu)
    build_cores=$(printf "%.0f" "$(echo "${all_cores} * 0.75" | bc)")
    echo "Switch nix-darwin ❄️ with ${build_cores} cores"
    nix run nix-darwin -- switch --flake "${HOME}/nix-config" --cores "${build_cores}" -L
else
    echo "ERROR! No nix-config found in ~/nix-config"
fi
