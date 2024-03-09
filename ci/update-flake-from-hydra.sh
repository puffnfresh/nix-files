#!/usr/bin/env bash

set -e

ENDPOINT="https://hydra.home.brianmckenna.org/jobset/puffnfresh/nix-files/evals"
EVALS="$(curl -s -H 'Accept: application/json' "$ENDPOINT")"

NODES="$(jq -r '.nodes | to_entries | map(.key + "," + .value.locked.type + ":" + .value.locked.owner + "/" + .value.locked.repo) | .[]' < flake.lock)"

args=""
for node in $NODES; do
    input="$(echo "$node" | cut -d , -f 1)"
    url="$(echo "$node" | cut -d , -f 2)"
    revision="$(echo "$EVALS" | jq -r ".evals[0].jobsetevalinputs[\"$input\"].revision")"
    if [ "$revision" = "null" ]; then
        continue
    fi
    echo ";; $input -> $revision"
    args="--override-input $input $url/$revision $args"
done

nix flake update $args
