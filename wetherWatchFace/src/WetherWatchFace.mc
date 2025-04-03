using Toybox.Application;
using Toybox.WatchUi as Ui;
using Toybox.Graphics as Gfx;
using Toybox.Time;
import Toybox.Time.Gregorian;
using Toybox.System;
using Toybox.ActivityMonitor as Act;
using Toybox.Timer;
using WeatherConditions;
using Toybox.WatchUi;

class WetherWatchFace extends Ui.WatchFace {
    private var _weatherData = null;
    private var _lastWeatherUpdate = 0;
    private var _weatherTimer;
    private var _lowPowerMode = false;
    private var _prevTemperature = null; // Speichert die vorherige Temperatur für Trendanzeige
    private var _elephantBitmap = null;  // Speichert das PHP-Elefant-Bild

    function initialize() {
        Ui.WatchFace.initialize();
        _lastWeatherUpdate = 0;
        _weatherTimer = new Timer.Timer();
        
        // Prüfe, ob der Akku schwach ist (unter 20%)
        var battery = System.getSystemStats().battery;
        _lowPowerMode = (battery <= 20);
        
        // Initialisiere simulierte Wetterdaten
        _weatherData = {
            "temperature" => 22,
            "conditions" => WeatherConditions.CONDITION_PARTLY_CLOUDY,
            "timestamp" => Time.now().value(),
            "highTemperature" => 25,
            "lowTemperature" => 18
        };
        
        // Lade das PHP-Elefant-Bild
        try {
            _elephantBitmap = Ui.loadResource(Rez.Drawables.PhpElephantImage);
            System.println("PHP-Elefantenbild erfolgreich geladen");
        } catch (e) {
            System.println("Fehler beim Laden des Elefantenbilds: " + e.getErrorMessage());
            _elephantBitmap = null;
        }
    }

    function onLayout(dc) {
        // Einfaches Layout
    }

    function onShow() {
        // Beim Anzeigen der Uhr Wetterdaten aktualisieren
        updateWeather();
    }
    
    function onExitSleep() {
        // Beim Aufwachen der Uhr Wetterdaten aktualisieren
        updateWeather();
    }

    function onUpdate(dc) {
        // Hintergrund löschen
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_BLACK);
        dc.clear();

        // Display-Abmessungen
        var width = dc.getWidth();
        var height = dc.getHeight();
        var centerX = width / 2;
        var centerY = height / 2;
        
        // Schwarzen Hintergrund für besseren Kontrast zeichnen
        dc.setColor(Gfx.COLOR_BLACK, Gfx.COLOR_TRANSPARENT);
        dc.fillCircle(centerX, centerY, width/2 - 12);
        
        // Hintergrundkreis in Dunkelgrau
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
        dc.drawCircle(centerX, centerY, width / 2 - 8);
        
        // Schrittziel und aktueller Schrittstand
        var activityInfo = Act.getInfo();
        var steps = activityInfo.steps;
        var stepGoal = activityInfo.stepGoal;
        var stepPercent = (stepGoal > 0) ? (steps.toFloat() / stepGoal.toFloat()) : 0.0;
        if (stepPercent > 1.0) {
            stepPercent = 1.0;
        }
        
        // Fortschrittskreis für Schritte in Orange basierend auf Schrittziel
        dc.setColor(0xFFA500, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(4);
        var arcLength = 360 * stepPercent;
        dc.drawArc(centerX, centerY, width / 2 - 8, Gfx.ARC_COUNTER_CLOCKWISE, 90, 90 - arcLength);
        
        // ---------------------------------------------------------------
        // KOMPLETT NEUES LAYOUT MIT EXTREMEN ABSTÄNDEN
        // ---------------------------------------------------------------
        
        // 1. Temperatur ganz oben
        dc.setColor(0x00AAFF, Gfx.COLOR_TRANSPARENT);
        var tempText = "??°C";
        if (_weatherData != null && _weatherData.hasKey("temperature")) {
            tempText = _weatherData.get("temperature").toString() + "°C";
        }
        dc.drawText(centerX, centerY - 90, Gfx.FONT_MEDIUM, tempText, Gfx.TEXT_JUSTIFY_CENTER);
        
        // 2. Uhrzeit - DEUTLICH höher positioniert
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        var clockTime = System.getClockTime();
        var hour = clockTime.hour;
        var minute = clockTime.min;
        var timeString = hour.format("%02d") + ":" + minute.format("%02d");
        
        // Uhrzeit weit über der Mitte positionieren
        dc.drawText(centerX, centerY - 40, Gfx.FONT_NUMBER_MEDIUM, timeString, Gfx.TEXT_JUSTIFY_CENTER);
        
        // 3. Absolut leerer Bereich für Abstand
        
        // 4. Datum - ERST NACH VIEL ABSTAND
        dc.setColor(Gfx.COLOR_LT_GRAY, Gfx.COLOR_TRANSPARENT);
        var now = Time.now();
        var info = Gregorian.info(now, Time.FORMAT_MEDIUM);
        var dateString = info.day + "." + info.month + "." + info.year;
        
        // Datum WEIT unter die Mitte positionieren
        dc.drawText(centerX, centerY + 40, Gfx.FONT_SMALL, dateString, Gfx.TEXT_JUSTIFY_CENTER);
        
        // 5. Schritte - ganz unten
        dc.setColor(Gfx.COLOR_WHITE, Gfx.COLOR_TRANSPARENT);
        var stepsText = steps.toString();
        // Schritte noch weiter nach unten
        dc.drawText(centerX, centerY + 75, Gfx.FONT_SMALL, stepsText, Gfx.TEXT_JUSTIFY_CENTER);
        
        // Elefantenbild wird entfernt
        // if (_elephantBitmap != null) {
        //     drawElephantImage(dc, centerX, centerY);
        // }
    }
    
    // Funktion zum Zeichnen des PHP-Elefant-Bildes - sehr klein und in der Ecke
    function drawElephantImage(dc, centerX, centerY) {
        if (_elephantBitmap != null) {
            var imageWidth = _elephantBitmap.getWidth();
            var imageHeight = _elephantBitmap.getHeight();
            
            // Das Bild auf ca. 20% des Displays skalieren - sehr klein
            var maxWidth = dc.getWidth() * 0.20;
            var scale = maxWidth / imageWidth;
            
            // Neue Dimensionen berechnen
            var newWidth = imageWidth * scale;
            var newHeight = imageHeight * scale;
            
            // Position weit nach rechts unten verschieben
            var posX = centerX + 50; // rechts verschieben
            var posY = centerY + 80; // unten verschieben
            
            // Bild zeichnen
            dc.drawBitmap(posX - newWidth, posY - newHeight, _elephantBitmap);
        }
    }
    
    // Hilfsfunktion zum Zeichnen eines Kreisbogens
    function drawArc(dc, centerX, centerY, radius, startDegree, endDegree, width, color, fillPercent) {
        var fullArc = endDegree - startDegree;
        var arc = fullArc * fillPercent;
        
        // Äußeren Kreisbogen in grau zeichnen
        dc.setColor(Gfx.COLOR_DK_GRAY, Gfx.COLOR_TRANSPARENT);
        dc.setPenWidth(width);
        dc.drawArc(centerX, centerY, radius, Gfx.ARC_CLOCKWISE, startDegree, endDegree);
        
        // Gefüllten Kreisbogen zeichnen
        if (fillPercent > 0) {
            dc.setColor(color, Gfx.COLOR_TRANSPARENT);
            dc.setPenWidth(width);
            dc.drawArc(centerX, centerY, radius, Gfx.ARC_CLOCKWISE, startDegree, startDegree + arc);
        }
    }
    
    // Funktion zum Aktualisieren der Wetterdaten
    function updateWeather() {
        var currentTime = Time.now().value();
        
        // Aktualisierungsintervall basierend auf Energiemodus
        var updateInterval = _lowPowerMode ? 3600 : 1800; // 1h im Stromspar-Modus, sonst 30min
        
        // Wetter nur aktualisieren, wenn das Intervall abgelaufen ist
        if (_lastWeatherUpdate == 0 || currentTime - _lastWeatherUpdate > updateInterval) {
            _lastWeatherUpdate = currentTime;
            
            // Prüfe Akkustand und aktualisiere den Low-Power-Modus
            var sysStats = System.getSystemStats();
            var battery = sysStats.battery;
            var batteryInt = battery.toNumber();
            _lowPowerMode = (batteryInt <= 20);
            
            // Vorherige Temperatur für den Trend speichern
            if (_weatherData != null && _weatherData.hasKey("temperature")) {
                _prevTemperature = _weatherData.get("temperature");
            }
            
            // Simuliere zufällige Wetterdaten
            var seed = System.getTimer() % 100;
            var temperature = 15 + (seed % 20); // Temperatur zwischen 15 und 34°C
            var condition = seed % 8; // Wetterbedingung zwischen 0 und 7
            
            if (_weatherData == null) {
                _weatherData = {
                    "temperature" => temperature,
                    "conditions" => condition,
                    "timestamp" => currentTime,
                    "highTemperature" => temperature + (2 + seed % 3), // Höchsttemperatur
                    "lowTemperature" => temperature - (2 + seed % 3)   // Tiefsttemperatur
                };
            } else {
                _weatherData.put("temperature", temperature);
                _weatherData.put("conditions", condition);
                _weatherData.put("timestamp", currentTime);
                _weatherData.put("highTemperature", temperature + (2 + seed % 3));
                _weatherData.put("lowTemperature", temperature - (2 + seed % 3));
            }
            
            // Timer für nächstes Update setzen
            _weatherTimer.stop();
            _weatherTimer.start(method(:updateWeather), updateInterval * 1000, false);
            
            // UI aktualisieren
            Ui.requestUpdate();
        }
    }
    
    // Funktion zum Zeichnen des Wetters
    function drawWeather(dc, x, y) {
        if (_weatherData == null) {
            return;
        }

        // Zeichne ein einfaches Wolkensymbol
        dc.setColor(0x00AAFF, Gfx.COLOR_TRANSPARENT);
        
        // Wolke zeichnen
        dc.fillCircle(x, y, 7);
        dc.fillCircle(x+8, y, 5);
        dc.fillCircle(x-5, y+5, 5);
        dc.fillRectangle(x-5, y, 13, 8);

        // Temperatur anzeigen
        var temperature = _weatherData.get("temperature");
        if (temperature != null) {
            var tempText = temperature.toNumber().toString() + "°C";
            dc.drawText(x + 20, y - 8, Gfx.FONT_SMALL, tempText, Gfx.TEXT_JUSTIFY_LEFT);
        }
    }
    
    // Einfachere Funktion zum Zeichnen eines statischen Wettersymbols
    function drawSimpleWeather(dc, x, y) {
        // Wetter-Symbol in hellblau zeichnen
        dc.setColor(0x00AAFF, Gfx.COLOR_TRANSPARENT);
        
        // Verbesserte Wolke zeichnen
        // Hauptteil der Wolke
        dc.fillCircle(x, y, 8);
        // Kleinere Teile der Wolke
        dc.fillCircle(x+7, y-2, 6);
        dc.fillCircle(x-7, y-1, 5);
        dc.fillCircle(x+12, y+2, 4);
        // Basis der Wolke
        dc.fillRectangle(x-7, y, 19, 8);
        
        // Temperatur anzeigen
        dc.setColor(0x00AAFF, Gfx.COLOR_TRANSPARENT);
        dc.drawText(x + 25, y - 4, Gfx.FONT_SMALL, "17°C", Gfx.TEXT_JUSTIFY_LEFT);
    }
    
    // Funktion zum Umwandeln der Wetterbedingung in ein Icon
    function getWeatherIcon(conditions) {
        if (conditions == WeatherConditions.CONDITION_CLEAR) {
            return "☀";
        } else if (conditions == WeatherConditions.CONDITION_PARTLY_CLOUDY) {
            return "⛅";
        } else if (conditions == WeatherConditions.CONDITION_MOSTLY_CLOUDY || 
                  conditions == WeatherConditions.CONDITION_CLOUDY) {
            return "☁";
        } else if (conditions == WeatherConditions.CONDITION_RAIN || 
                  conditions == WeatherConditions.CONDITION_DRIZZLE) {
            return "🌧";
        } else if (conditions == WeatherConditions.CONDITION_SNOW) {
            return "❄";
        } else if (conditions == WeatherConditions.CONDITION_THUNDERSTORMS) {
            return "⚡";
        } else {
            return "?";
        }
    }
    
    // Neue Funktion für Schrittfarbe
    function getStepsColor(percent) {
        // Verwende Orange als Hauptfarbe für Schritte wie im Screenshot
        return 0xFFA500; // Orange
    }
    
    function getBatteryColor(batteryLevel) {
        if (batteryLevel > 50) {
            return 0x00AAFF; // Hellblau für guten Batteriestand
        } else if (batteryLevel > 20) {
            return 0xFFA500; // Orange für mittleren Batteriestand
        } else {
            return Gfx.COLOR_RED; // Rot für niedrigen Batteriestand
        }
    }
}
