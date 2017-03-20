#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "aprsis.h"
#include "aprspacket.h"

int main(int argc, char *argv[])
{
    //QT Inbuilt shindig to intialise app
    QGuiApplication app(argc, argv);
    //Required inputs for settings
    app.setOrganizationName("Hibby");
    app.setOrganizationDomain("https://foxk.it");
    app.setApplicationName("Teset");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    //intialise APRS-IS

    aprsis sock;
    sock.aprsConnect();
    return app.exec();
}
