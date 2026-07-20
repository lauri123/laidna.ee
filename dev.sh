#!/usr/bin/env bash
# Local dev server, using the same pinned Hugo image as the server.
# Usage: ./dev.sh            -> http://localhost:1313 (drafts shown)
#        ./dev.sh mod get -u -> run any other hugo subcommand
set -euo pipefail

IMAGE="hugomods/hugo:debian-dart-sass-go-git-0.164.0"
CACHE_DIR="$HOME/.cache/laidna-hugo"

if [ $# -eq 0 ]; then
  set -- hugo server -D --bind 0.0.0.0 --baseURL http://localhost:1313
else
  set -- hugo "$@"
fi

# Allocate a TTY only when there is one. Without this guard the script fails
# with "the input device is not a TTY" under any non-interactive runner.
TTY_FLAGS=()
[ -t 0 ] && TTY_FLAGS=(-it)

# The image runs as root. Without --user, everything it writes into the bind
# mount is root-owned and this account cannot edit its own site afterwards.
# The cache is a host directory rather than a named volume for the same
# reason: a named volume would be root-owned and unwritable under --user.
mkdir -p "$CACHE_DIR"

exec docker run --rm "${TTY_FLAGS[@]}" \
  --user "$(id -u):$(id -g)" \
  -v "$PWD:/src" -w /src \
  -v "$CACHE_DIR:/cache" \
  -e HOME=/tmp \
  -e HUGO_CACHEDIR=/cache \
  -e GOPATH=/cache/go \
  -p 1313:1313 \
  "$IMAGE" "$@"
