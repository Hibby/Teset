import QtQuick 2.5
import QtQuick.Controls 1.4
import QtPositioning 5.7
import QtQuick.Window 2.0


ApplicationWindow {
    id: prefs
    title: qsTr("Teset APRS - Properties")
    width: 512
    height: 512
    visible: false

    Text {
        id: introText
        x: 40
        y: 40
        width: 400
        text: qsTr("Below are the majority of major settings held by the application.")
        wrapMode: Text.WordWrap
    }

    Text {
        id: callText
        width: 60
        text: qsTr("Callsign:")
        anchors.top: introText.bottom
        anchors.topMargin: 5
        anchors.left: parent.left
        anchors.leftMargin: 40
        font.pixelSize: 12
    }

    TextField {
        id: callInput
        width: 80
        text: callsign
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.top: callText.bottom
        anchors.topMargin: 5
        font.pixelSize: 12
        maximumLength: 8
    }

    Text {
        id: ssidText
        x: 7
        y: 7
        width: 60
        text: qsTr("APRS SSID:")
        anchors.left: parent.left
        anchors.leftMargin: 175
        anchors.topMargin: 5
        anchors.top: introText.bottom
    }

    ComboBox {
        id: ssidSelect
        anchors.left: parent.left
        anchors.leftMargin: 175
        anchors.top: ssidText.bottom
        anchors.topMargin: 5
        model: ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
        currentIndex: ssid-1
    }

    Text {
        id: passcodeText
        x: 5
        y: 5
        width: 60
        text: qsTr("Passcode:")
        anchors.left: parent.left
        anchors.leftMargin: 175
        anchors.topMargin: 5
        anchors.top: aprsisText.bottom
        font.pixelSize: 12
    }

    TextField {
        id: passcodeInput
        x: 5
        width: 80
        text: passcode
        anchors.left: passcodeText.left
        anchors.leftMargin: 0
        anchors.topMargin: 5
        maximumLength: 8
        anchors.top: passcodeText.bottom
        font.pixelSize: 12
    }

    Text {
        id: homestnText
        width: 400
        text: qsTr("Home Station Details:")
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.top: introText.bottom
        anchors.topMargin: 80
        wrapMode: Text.WordWrap
    }

    Text {
        id: latText
        width: 60
        text: qsTr("Latitude:")
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.top: homestnText.bottom
        anchors.topMargin: 5
    }

    TextField {
        id: latInput
        width: 60
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.topMargin: 5
        text: homeLat
        echoMode: TextInput.Normal
        anchors.top: latText.bottom
        validator: DoubleValidator{
            bottom: -180
            top: 180
        }
        inputMask: "#000.0000"
    }

    Text {
        id: lonText
        text: qsTr("Longitude:")
        anchors.left: parent.left
        anchors.leftMargin: 175
        anchors.top: homestnText.bottom
        anchors.topMargin: 5
        font.pixelSize: 12
    }

    TextField {
        id: lonInput
        width: 60
        text: homeLon
        anchors.left: parent.left
        anchors.leftMargin: 175
        anchors.top: lonText.bottom
        anchors.topMargin: 5
        font.pixelSize: 12
        validator: DoubleValidator{
            bottom: -90
            top: 90
        }
        inputMask: "#00.000"
    }

    Text {
        id: radiusText
        text: qsTr("Radius:")
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.topMargin: 5
        anchors.top: aprsisText.bottom
        font.pixelSize: 12
    }

    TextField {
        id: radiusInput
        width: 60
        text: radius
        anchors.left: radiusText.left
        inputMask: "000"
        anchors.leftMargin: 0
        anchors.topMargin: 5
        anchors.top: radiusText.bottom
        font.pixelSize: 12
        validator: DoubleValidator {
            bottom: -90
            top: 90
        }
    }

    Button {
        id: saveButton
        text: "&Save"
        anchors.bottom: parent.bottom
        anchors.right: cancelButton.left
        anchors.rightMargin: 5
        onClicked: saveVars()
    }

    Button {
        id: cancelButton
        text: "&Cancel"
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        onClicked: prefs.destroy()
    }

    Text {
        id: aprsisText
        x: -4
        width: 400
        text: qsTr("APRS-IS Details:")
        anchors.left: parent.left
        anchors.leftMargin: 40
        anchors.topMargin: 80
        anchors.top: homestnText.bottom
        wrapMode: Text.WordWrap
    }

    CheckBox {
        id: aprsisInput
        anchors.top: aprsisConnect.bottom
        anchors.topMargin: 5
        anchors.left: aprsisConnect.left
        anchors.leftMargin: 0
        checked: aprsisConnection

    }

    Text {
        id: aprsisConnect
        text: qsTr("Connect to APRS-IS?")
        anchors.left: parent.left
        anchors.leftMargin: 300
        anchors.top: aprsisText.bottom
        anchors.topMargin: 5
        font.pixelSize: 12
    }

    function saveVars()
    {
        //save values for use in program
        callsign = callInput.text
        ssid = ssidSelect.currentText
        passcode = passcodeInput.text
        homeLat = latInput.text
        homeLon = lonInput.text
        radius = radiusInput.text
        aprsisConnection = aprsisInput.checkedState
        // write to config file
        settings.callsign = callsign
        settings.ssid = ssid
        settings.passcode = passcode
        settings.homeLat = homeLat
        settings.homeLon = homeLon
        settings.radius = radius
        settings.aprsisConnection = aprsisConnection
        prefs.destroy()
    }
}
