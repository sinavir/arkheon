#!/usr/bin/env bash

set -o pipefail
set -o errexit
set -o nounset

TOP_LEVEL=$(nix --extra-experimental-features nix-command path-info /run/current-system)

# jq is used in a hacky way to cope with differences of output between nix and lix
nix --extra-experimental-features nix-command path-info --closure-size -rsh /run/current-system --json \
| jq 'to_entries | map({path: .key, valid: true} + .value)' \
| curl --fail-with-body  -X POST \
	-H "Content-Type: application/json" \
	-H "X-Token: notoken" \
	-H "X-Operator: $ARKHEON_OPERATOR" \
	-H "X-TopLevel: $TOP_LEVEL" \
	--data @- \
	"${ARKHEON_HOST:-http://localhost:8000}/record/$(hostname)"
