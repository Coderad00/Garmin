#!/bin/bash
set -e

# Pfade
WORKSPACE="$PWD"
APP="WeatherWatchFace"
OUT="$WORKSPACE/build/${APP}.prg"
DEVICE="epix2"
KEY="$WORKSPACE/wetherWatchFace/developer_key"

# Build-Verzeichnis erstellen
mkdir -p "$WORKSPACE/build"

# Direkter Aufruf des monkeyc-Tools
monkeyc \
  -o "$OUT" \
  -f "$WORKSPACE/wetherWatchFace/monkey.jungle" \
  -d epix2 \
  -y "$KEY" \
  --debug-log-level 3

echo "✅ Build complete: $OUT"
