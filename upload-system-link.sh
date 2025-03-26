#!/usr/bin/env bash

# jq is used in a hacky way to cope with differences of output between nix and lix
nix path-info --extra-experimental-features nix-command path-info --closure-size -rsh "/nix/var/nix/profiles/system-$1-link" --json \
| jq 'to_entries | map({path: .key, valid: true} + .value)' \
| curl -X POST \
	-H "Content-Type: application/json" \
	--data @- \
	"${ARKHEON_HOST:-http://localhost:8000}/record/$(hostname)"
