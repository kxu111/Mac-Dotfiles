#!/bin/bash

set -euo pipefail

bundle_id="$1"
workspace="$2"

open_app() {
	aerospace workspace "$workspace"
	open -b "$bundle_id"
	exit 0
}

APP_NAME=$(aerospace list-apps | awk -F'|' -v bid="$bundle_id" '
  {
    gsub(/^[ \t]+|[ \t]+$/, "", $2)
    gsub(/^[ \t]+|[ \t]+$/, "", $3)

    if ($2 ~ "^" bid "$") {
      print $3
      exit
    }
  }
')

if [[ -z "${APP_NAME:-}" ]]; then
	echo "Could not resolve app name for bundle: $bundle_id"
	open_app
fi

WIN_ID=$(aerospace list-windows --all | awk -F'|' -v app="$APP_NAME" '
  {
    gsub(/^[ \t]+|[ \t]+$/, "", $2)
    gsub(/^[ \t]+|[ \t]+$/, "", $1)

    if ($2 ~ "^" app "$") {
      print $1
      exit
    }
  }
')

if [[ -z "${WIN_ID:-}" ]]; then
	echo "No window found for app: $APP_NAME"
	open_app
fi

aerospace focus --window-id "$WIN_ID"

CURRENT_WS=$(aerospace list-workspaces --focused)

if [[ "$CURRENT_WS" != "$workspace" ]]; then
	aerospace move-node-to-workspace "$workspace" --window-id "$WIN_ID"
	aerospace focus --window-id "$WIN_ID"
	exit 0
fi
