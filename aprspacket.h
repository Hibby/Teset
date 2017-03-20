#ifndef APRSPACKET_H
#define APRSPACKET_H

#include <QObject>
#include <QString>

class aprspacket : public QObject
{
    Q_OBJECT
public:
   //explicit aprspacket(QObject *parent = 0);
   aprspacket();
   void parseAPRS(char *input);

signals:
private slots:
private:
};

#endif // APRSPACKET_H
