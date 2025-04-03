# PHP Weather Watchface für Garmin

Eine minimalistische Watchface für Garmin-Smartwatches mit Temperaturanzeige, Uhrzeit, Datum und Schrittzähler.

## Installation

Es gibt mehrere Möglichkeiten, das Watchface auf deine Garmin-Uhr zu übertragen:

### Methode 1: Direkt über das Terminal (für Entwickler)

Das Watchface wurde bereits kompiliert und kann mit monkeydo auf einem Simulator getestet oder direkt auf eine angeschlossene Uhr übertragen werden:

```bash
# Für Simulator-Tests:
monkeydo build/WeatherWatchFace.prg epix2

# Direkt auf die Uhr übertragen (falls die Uhr angeschlossen ist):
monkeydo build/WeatherWatchFace.prg
```

### Methode 2: Über Garmin Express

1. Verbinde deine Garmin-Uhr über USB mit deinem Computer
2. Öffne Garmin Express (falls nicht installiert, [hier herunterladen](https://www.garmin.com/de-DE/software/express/))
3. Wähle deine Uhr in Garmin Express aus
4. Gehe zu "IQ-Apps" oder "Apps verwalten"
5. Klicke auf "Apps hinzufügen" und wähle "Aus Datei installieren"
6. Navigiere zum `build`-Verzeichnis und wähle die Datei `WeatherWatchFace.prg` aus
7. Folge den Anweisungen auf dem Bildschirm

### Methode 3: Über Garmin Connect Mobile (Smartphone)

1. Kopiere die `WeatherWatchFace.prg`-Datei vom `build`-Verzeichnis auf dein Smartphone
2. Öffne die Garmin Connect App auf deinem Smartphone
3. Tippe auf das Menüsymbol und wähle "Connect IQ Store"
4. Tippe auf das Menü (drei Punkte) und wähle "Von Gerät installieren"
5. Wähle die `WeatherWatchFace.prg`-Datei aus
6. Wähle deine Uhr aus und folge den Anweisungen

### Methode 4: Manuell über USB

1. Verbinde deine Garmin-Uhr über USB mit deinem Computer
2. Die Uhr sollte als Wechseldatenträger erkannt werden
3. Navigiere zum Ordner `GARMIN/APPS` auf der Uhr
4. Kopiere die `WeatherWatchFace.prg`-Datei in diesen Ordner
5. Trenne die Verbindung sicher und starte deine Uhr neu

## Layout des Watchfaces

Das aktuelle Layout des Watchfaces zeigt:

- **Oben**: Aktuelle Temperatur in Blau
- **Mitte**: Uhrzeit in Großschrift
- **Unten**: Datum (Tag.Monat.Jahr)
- **Ganz unten**: Aktuelle Schrittzahl
- **Außenring**: Orangefarbener Fortschrittsring für das tägliche Schrittziel

## Anpassungsmöglichkeiten

Um das Watchface anzupassen:

1. Öffne die Datei `WetherWatchFace.mc` im `src`-Verzeichnis
2. Ändere folgende Parameter nach Wunsch:
   - Farben: Suche nach `setColor` und ändere die Farbwerte
   - Positionen: Ändere die Y-Koordinaten (z.B. `centerY - 90` für die Temperatur)
   - Schriftarten: Ändere `FONT_MEDIUM`, `FONT_NUMBER_MEDIUM` etc.
3. Kompiliere das Watchface neu mit:
   ```bash
   monkeyc -f wetherWatchFace/monkey.jungle -o build/WeatherWatchFace.prg -d epix2 -y wetherWatchFace/developer_key
   ```

## Fehlerbehebung

- **Uhr wird nicht erkannt**: Stelle sicher, dass die Uhr im MTP-Modus (nicht nur zum Laden) angeschlossen ist
- **Watchface wird nicht angezeigt**: Gehe auf der Uhr zu Einstellungen > Uhranzeige und wähle das Watchface manuell aus
- **Temperatur wird nicht angezeigt**: Das Watchface simuliert derzeit Wetterdaten. Für echte Wetterdaten müsstest du eine Wetter-API anbinden

## Entwicklung

Für die Weiterentwicklung des Watchfaces benötigst du:

- Garmin Connect IQ SDK (herunterladen von [Garmin Developer](https://developer.garmin.com/connect-iq/sdk/))
- Monkey C Compiler (`monkeyc`)
- Ein Developer-Key (in `wetherWatchFace/developer_key`) 