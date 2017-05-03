#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtSql>
#include "aprsis.h"
#include "aprspacket.h"

QSqlError initDb(){
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    // Open database file. The driver creates a new file if it doesn't exist yet.
    db.setDatabaseName("teset.sqlite");
    if (!db.open()){
        qDebug() << "closed";
        return db.lastError();
    }

    QStringList tables = db.tables();
    if (tables.contains("stations", Qt::CaseInsensitive)) {
        // DB has already been populated
        return QSqlError();
    }

    return QSqlError();
}

int main(int argc, char *argv[])
{
    //QT Inbuilt shindig to intialise app
    QGuiApplication app(argc, argv);
    auto err = initDb();
     if (err.type() != QSqlError::NoError) {
         qCritical() << err.text();
         return 1;
     }
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
