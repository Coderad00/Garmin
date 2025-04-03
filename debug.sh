#!/bin/bash
set -e

monkeyc \
  -o build/WeatherWatchFace.prg \
  -f wetherWatchFace/monkey.jungle \
  -d epix2 \
  -y wetherWatchFace/developer_key \
  -g \
  --debug-log-level 3 \
  --warn

# Starten mit Debugging-Informationen
monkeydo build/WeatherWatchFace.prg epix2 -t

echo "App started with debugging enabled" 