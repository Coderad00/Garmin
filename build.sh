#!/bin/bash
set -e

APP="WeatherWatchFace"
OUT="build/${APP}.prg"
DEVICE="epix2"
KEY="wetherWatchFace/developer_key"

mkdir -p build

monkeyc \
  -o "$OUT" \
  -f wetherWatchFace/monkey.jungle \
  -d epix2 \
  -y "$KEY" \
  --debug-log-level 3

echo "✅ Build complete: $OUT"
