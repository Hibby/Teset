#include "aprspacket.h"
#include <QVariant>
#include <QDebug>
#include <QString>
#include <QtSql>
#include <QDateTime>
#include <fap.h>


aprspacket::aprspacket()
{
}

// Incoming data from aprsis.cpp - readyRead function
void aprspacket::parseAPRS(char *input) {
    qDebug() << "Initialising LibFap";
    fap_packet_t* packet;
    unsigned int input_len = strlen(input);
    char errmsg[256];
    fap_init();
    qDebug() << "initialised";
    packet = fap_parseaprs(input, input_len, 0);
    qDebug() << "packet input";
    if ( packet->error_code )
            {
                    qDebug() << "packet error";
                    fap_explain_error(*packet->error_code, errmsg);
                    qDebug() << errmsg;
            }
            else if ( packet->src_callsign )
            {
                    qDebug() << "packet parsed";
                    qDebug() << packet->src_callsign;
                    qDebug() << *packet->type;
                    qDebug() << *packet->latitude;
                    qDebug() << *packet->longitude;
                    //newPacketChanged(packet->src_callsign);
                    QSqlQuery query;
                    if (!query.exec(QLatin1String("create table stations(callsign varchar, type int, latitude float, longitude float, comment varchar, timestamp qint64)"))){
                    }
                    query.prepare("INSERT INTO stations (callsign, type, latitude, longitude, comment, timestamp) " "VALUES (?, ?, ?, ?, ?, ?)");
                    query.addBindValue(packet->src_callsign);
                    query.addBindValue(*packet->type);
                    query.addBindValue(*packet->latitude);
                    query.addBindValue(*packet->longitude);
                    query.addBindValue(packet->comment);
                    query.addBindValue(QDateTime::currentMSecsSinceEpoch()/1000);
                    query.exec();

            }
            qDebug() << "packet cleaning";
            fap_free(packet);
            fap_cleanup();

}
