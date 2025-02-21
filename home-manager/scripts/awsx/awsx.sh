#!/usr/bin/env bash

if [ "$#" -gt 0 ]; then
export AWS_PROFILE="$1"
else
tmp=$(sed -n 's/\[profile \(.*\)\]/\1/gp' ~/.aws/config | ${pkgs.fzf}/bin/fzf)

if [ -z "$tmp" ]; then
    exit 130
fi

export AWS_PROFILE="$tmp"
fi
