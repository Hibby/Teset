#include <QGuiApplication>
#include <QQmlApplicationEngine>

int main(int argc, char *argv[])
{      
    QGuiApplication app(argc, argv);
    app.setOrganizationName("Hibby");
    app.setOrganizationDomain("https://foxk.it");
    app.setApplicationName("Teset");

    QQmlApplicationEngine engine;
    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}

struct Preferences
{
    double homeLat;
    double homeLon;
    double callsign;
};
