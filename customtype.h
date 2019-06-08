#ifndef CUSTOMTYPE_H
#define CUSTOMTYPE_H

#include <QObject>

class CustomType : public QObject {
    Q_OBJECT
    Q_PROPERTY(QString text READ text WRITE setText NOTIFY textChanged)

public:
    explicit CustomType(QObject* parent = 0);
    CustomType(const CustomType& other);
    ~CustomType();

    QString text();
    void setText(QString text);

signals:
    void textChanged();

private:
    QString myText;
};

Q_DECLARE_METATYPE(CustomType)

#endif // CUSTOMTYPE_H
