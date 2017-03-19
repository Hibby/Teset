import QtQuick 2.5
import QtQuick.Controls 1.4
import QtQuick.Window 2.1
import QtLocation 5.7
import QtPositioning 5.7
import Qt.labs.settings 1.0


// Create Window
ApplicationWindow {
    id: teset
    title: "Teset APRS"
    width: 1024
    height: 512
    visible: true

    property double homeLat: settings.homeLat
    property double homeLon: settings.homeLon
    property string callsign: settings.callsign
    property string ssid: settings.ssid
    property string passcode: settings.passcode
    property int radius: settings.radius
    property bool aprsisConnection: settings.aprsisConnection
    //Intiialise settings - where does this file live?
    Settings {
    id: settings
    // Home station settings
    property double homeLat: 57.15
    property double homeLon: -2.1
    property string callsign: "N0CALL"
    property string ssid: "1"
    property string passcode: ""
    property int radius: 50
    property bool aprsisConnection: false
    // Window Size Prefs
    property alias x: teset.x
    property alias y: teset.y
    property alias width: teset.width
    property alias height: teset.height
    }


    //set home values
    property variant homeCoordinate: QtPositioning.coordinate(homeLat, homeLon)

    Plugin {
        id: mapPlugin
        name: "osm"
         PluginParameter {
            name: "osm.mapping.highdpi_tiles"
            value: "true"
         }
         PluginParameter {
             name: "osm.useragent"
             value: "Teset APRS 0.1"
         }

      }
    // Create helper functions

    function showPreferences()
    {
        var component = Qt.createComponent("forms/preferences.qml")
        var window    = component.createObject(teset)
        window.show()
   }
    function showAbout()
    {
        var component = Qt.createComponent("forms/about.qml")
        var window    = component.createObject(teset)
        window.show()
   }
    function refreshCache()
    {
        map.clearData()
        map.prefetchData()
    }
    function recenterMap()
    {
        map.center = homeCoordinate
        map.zoomLevel = 13
    }


    Map {
        id: map
        anchors.fill: parent
        plugin: mapPlugin
        center: homeCoordinate
        maximumZoomLevel: 16
        minimumZoomLevel: 0
        zoomLevel: 13
        copyrightsVisible: true
        gesture.acceptedGestures: MapGestureArea.PanGesture | MapGestureArea.FlickGesture | MapGestureArea.PinchGesture
        gesture.flickDeceleration: 2000
        gesture.enabled: true
        property int lastX: -1
        property int lastY: -1
        property int pressX: -1
        property int pressY: -1

    MouseArea {
        id: mouseArea
        property variant lastCoordinate
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onDoubleClicked: {
            var mouseGeoPos = map.toCoordinate(Qt.point(mouse.x, mouse.y));
            var preZoomPoint = map.fromCoordinate(mouseGeoPos, false);
            if (mouse.button === Qt.LeftButton) {
                map.zoomLevel++;
            } else if (mouse.button === Qt.RightButton) {
                map.zoomLevel--;
            }
            var postZoomPoint = map.fromCoordinate(mouseGeoPos, false);
            var dx = postZoomPoint.x - preZoomPoint.x;
            var dy = postZoomPoint.y - preZoomPoint.y;

            var mapCenterPoint = Qt.point(map.width / 2.0 + dx, map.height / 2.0 + dy);
            map.center = map.toCoordinate(mapCenterPoint);
        }



       onClicked: {
           if (mouse.button === Qt.RightButton)
           contextPopup.popup()

           }
        }
    }

    Menu {
        id: contextPopup

        MenuItem {
            text: "Set Home Location Here"

        }
        MenuItem {
            text: "Item 2"
        }
    }

    menuBar: MenuBar {
        Menu {
        title: "&File"

            MenuItem {
                text: "&Quit"
                shortcut: "Alt-F4"
                onTriggered: Qt.quit()
            }
        }

        Menu {
        title: "&Edit"

            MenuItem {
                text: "&Properties"
                shortcut: "Ctrl-."
                onTriggered: showPreferences()
                      }
            }

        Menu {
            title: "&Map Control"

            MenuItem {
                text: "&Center Map on Home"
                onTriggered: recenterMap()
            }
            MenuItem {
                text: "Refresh Map Cache"
                onTriggered: refreshCache()
            }
        }
        Menu {
            title: "&APRS Control"
        }

        Menu {
            title: "&Help"

            MenuItem {
                text: "&Help"
                shortcut: "F1"
            }

            MenuItem {
                text: "&About"
                onTriggered: showAbout()
            }
        }
    }
    Slider {
        id: zoomSlider;
        z: map.z + 3
        minimumValue: map.minimumZoomLevel;
        maximumValue: map.maximumZoomLevel;
        anchors.margins: 10
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.right: parent.right
        orientation : Qt.Vertical
        value: map.zoomLevel
        onValueChanged: {
            if (value >= 0)
                map.zoomLevel = value
        }
    }
    /* Component.onDestruction: {
        settings.callsign = teset.callsign
        settings.homeLat = teset.homeLat
        settings.homeLon = teset.homeLon
        settings.ssid = teset.ssid
        settings.passcode = teset.passcode
    } */

}

