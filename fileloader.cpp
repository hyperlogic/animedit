//
//  FileLoader
//
//  Created by Anthony Thibault on 6/5/2019
//  Copyright 2019 High Fidelity, Inc.
//
//  Distributed under the Apache License, Version 2.0.
//  See the accompanying file LICENSE or http://www.apache.org/licenses/LICENSE-2.0.html
//

#include "fileloader.h"

#include <QDebug>
#include <QFile>

QString FileLoader::readAll(QString filename) {
    QFile file(filename);
    if (!file.exists()) {
        qCritical() << "loadFile: failed to open file" << filename.data();
        return "";
    } else if (!file.open(QIODevice::ReadOnly)) {
        qCritical() << "loadFile: failed to open file" << filename.data();
        return "";
    } else {
        qDebug() << "loadFile: success opening file" << filename;
        return file.readAll();
    }
}
