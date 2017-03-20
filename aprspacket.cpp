#include "aprspacket.h"
#include <QVariant>
#include <QDebug>
#include <QString>
#include <fap.h>

aprspacket::aprspacket()
{
}

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
            }
            qDebug() << "packet cleaning";
            fap_free(packet);
            fap_cleanup();

}
