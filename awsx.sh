#!/usr/bin/env bash

if [ "$#" -gt 0 ]; then
    export AWS_PROFILE="$1"
else
    tmp=$(sed -n 's/\[profile \(.*\)\]/\1/gp' ~/.aws/config | fzf)
    echo $tmp

    if [ -z "$tmp" ]; then
        exit 130
    fi

set -U AWS_PROFILE $tmp
fi

