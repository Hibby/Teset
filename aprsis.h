#ifndef APRSIS_H
#define APRSIS_H

#include <QObject>
#include <QTcpSocket>
#include <QAbstractSocket>
#include <QDebug>
using namespace std;

struct prefStruct
{
    string callsign;
    string passcode;
    string ssid;
    string homeLat;
    string homeLon;
};

class aprsis : public QObject
{
    Q_OBJECT
public:
    explicit aprsis(QObject *parent = 0);

    void aprsConnect();

private slots:
    void connected();
    void disconnected();
    void bytesWritten(qint64 bytes);
    void readyRead();

private:
    QTcpSocket *socket;
    void aprsLogin(QString uname, QString upass, QString filter);
    void loadSettings();

};

#endif // APRSIS_H
