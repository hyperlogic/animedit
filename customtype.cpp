#include "customtype.h"

CustomType::CustomType(QObject* parent) : QObject(parent) {
}

CustomType::CustomType(const CustomType& other) {
    myText = other.myText;
}

CustomType::~CustomType() {
}

QString CustomType::text() {
    return myText;
}

void CustomType::setText(QString text) {
    myText = text;
    emit textChanged();
}
