#include "aprsis.h"
#include <QSettings>
#include <QVariant>
#include "aprspacket.h"

aprsis::aprsis(QObject *parent) :   QObject(parent)
{
}

void aprsis::aprsConnect()
{
    // make our socket, connect it to the signals from QTcpSocket
    socket = new QTcpSocket(this);
    connect(socket, SIGNAL(connected()),this, SLOT(connected()));
    connect(socket, SIGNAL(disconnected()),this, SLOT(disconnected()));
    connect(socket, SIGNAL(bytesWritten(qint64)),this, SLOT(bytesWritten(qint64)));
    connect(socket, SIGNAL(readyRead()),this, SLOT(readyRead()));

    // Check if we actually /want/ to connect to the host...
    QSettings settings;
    bool isAPRSIS = settings.value("aprsisConnection", "true").toBool();

    if (isAPRSIS) {
    qDebug() << "connecting...";

    // non blocking connect
    socket->connectToHost("euro.aprs2.net", 14580);

    // wait for any errors and shoot them out
    if(!socket->waitForConnected(5000))
    {
        qDebug() << "Error: " << socket->errorString();
    }
    } else {
        qDebug() << "I don't want an APRS-IS connection";
    }

}

void aprsis::aprsLogin(QString uname, QString upass, QString filter)
{
    // Concatenate my login details, I cold probably do this earlier
    QString login = "user " + uname + " pass " + upass + " vers Teset 0.1 filter " + filter + "\n";
    // QTCPSocket wants a bytearray.
    QByteArray ba = login.toLocal8Bit();
    qDebug() << ba;

    socket->write(ba);

}

void aprsis::loadSettings()
{
    /* This function pulls settings from the config file. If they aren't valid, it'll fill in nonsense.
     * This is quite a rough way of doing it, I'd like a private struct for all the details and then use
     * those members to populate the other values.
     * That said... it works
     */
    QSettings settings;
    QString callsign = settings.value("callsign", "N0CALL").toString();
    QString passcode = settings.value("passcode", "-1").toString();
    QString ssid = settings.value("ssid", "1").toString();
    QString homeLat = settings.value("homeLat", "52").toString();
    QString homeLon = settings.value("homeLon", "0").toString();
    QString radius = settings.value("Radius", "50").toString();

    QString filter = "r/"+homeLat+"/"+homeLon+"/"+radius;
    QString username = callsign + "-" + ssid;

    qDebug() << "Settings: " + username + ssid + passcode + ssid + filter;

    aprsLogin(username,passcode,filter);
}

void aprsis::connected()
{
    qDebug() << "connected...";

    loadSettings();
}

void aprsis::disconnected()
{
    qDebug() << "disconnected...";
}

void aprsis::bytesWritten(qint64 bytes)
{
    qDebug() << bytes << " bytes written...";
}

void aprsis::readyRead()
{

    qDebug() << "reading...";

    // read the data from the socket

    QByteArray interim = socket->read(256);

    char *msg = interim.data();

    qDebug() << msg;

   //libfap goes in here
   if (msg[0] == '#') {
   qDebug() << "Not interested in this packet";
   } else {
   aprspacket packet;
   packet.parseAPRS(msg);
    }
}
