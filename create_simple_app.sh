#!/bin/bash
set -e

# Aktuelle Verzeichnispfade
CURRENT_DIR="/Users/konrad.maedler/VsCodeProjects/Garmin"
SIMPLE_DIR="$CURRENT_DIR/SimpleWatchFace"
DEV_KEY="$CURRENT_DIR/wetherWatchFace/developer_key"

# Verzeichnis erstellen
mkdir -p "$SIMPLE_DIR/source"
mkdir -p "$SIMPLE_DIR/resources/strings"
mkdir -p "$SIMPLE_DIR/resources/drawables"

# Simple App erstellen
cat > "$SIMPLE_DIR/source/SimpleWatchFaceApp.mc" << 'EOL'
using Toybox.Application;

class SimpleWatchFaceApp extends Application.AppBase {
    function initialize() {
        AppBase.initialize();
    }

    function onStart(state) {
    }

    function onStop(state) {
    }

    function getInitialView() {
        return [ new SimpleWatchFaceView() ];
    }
}
EOL

cat > "$SIMPLE_DIR/source/SimpleWatchFaceView.mc" << 'EOL'
using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Time;

class SimpleWatchFaceView extends WatchUi.WatchFace {
    function initialize() {
        WatchFace.initialize();
    }

    function onLayout(dc) {
    }

    function onUpdate(dc) {
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();
        
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [
            clockTime.hour.format("%02d"),
            clockTime.min.format("%02d")
        ]);
        
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, dc.getHeight()/2, Graphics.FONT_LARGE, timeString, Graphics.TEXT_JUSTIFY_CENTER);
    }
}
EOL

# Manifest
cat > "$SIMPLE_DIR/manifest.xml" << 'EOL'
<?xml version="1.0"?>
<iq:manifest xmlns:iq="http://www.garmin.com/xml/connectiq" version="3">
    <iq:application entry="SimpleWatchFaceApp" id="f91c4356365747559d4d6cb38a82ae5d" launcherIcon="@Drawables.LauncherIcon" minSdkVersion="5.1.0" name="@Strings.AppName" type="watchface" version="1.0.0">
        <iq:products>
            <iq:product id="epix2"/>
        </iq:products>
        <iq:permissions/>
        <iq:languages>
            <iq:language>deu</iq:language>
            <iq:language>eng</iq:language>
        </iq:languages>
        <iq:barrels/>
    </iq:application>
</iq:manifest>
EOL

# Strings
cat > "$SIMPLE_DIR/resources/strings/strings.xml" << 'EOL'
<strings>
    <string id="AppName">Simple Watch</string>
</strings>
EOL

# Drawables
cat > "$SIMPLE_DIR/resources/drawables/drawables.xml" << 'EOL'
<drawables>
    <bitmap id="LauncherIcon" filename="launcher_icon.png" />
</drawables>
EOL

# Einfaches Dummy-Icon (1x1 px)
printf "\x89\x50\x4E\x47\x0D\x0A\x1A\x0A\x00\x00\x00\x0D\x49\x48\x44\x52\x00\x00\x00\x01\x00\x00\x00\x01\x08\x02\x00\x00\x00\x90\x77\x53\xDE\x00\x00\x00\x01\x73\x52\x47\x42\x00\xAE\xCE\x1C\xE9\x00\x00\x00\x09\x70\x48\x59\x73\x00\x00\x0B\x13\x00\x00\x0B\x13\x01\x00\x9A\x9C\x18\x00\x00\x00\x0C\x49\x44\x41\x54\x08\xD7\x63\x60\x60\x60\x00\x00\x00\x04\x00\x01\xE2\x28\x0F\x9D\x00\x00\x00\x00\x49\x45\x4E\x44\xAE\x42\x60\x82" > "$SIMPLE_DIR/resources/drawables/launcher_icon.png"

# Jungle-Datei
cat > "$SIMPLE_DIR/monkey.jungle" << 'EOL'
project.manifest = manifest.xml
EOL

# Kompilieren
cd "$HOME/Library/Application Support/Garmin/ConnectIQ/"
monkeyc -o "$CURRENT_DIR/SimpleWatchFace.prg" -f "$SIMPLE_DIR/monkey.jungle" -d epix2 -y "$DEV_KEY"

echo "Simple app created and compiled at $CURRENT_DIR/SimpleWatchFace.prg" 