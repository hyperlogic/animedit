//
//  FileLoader
//
//  Created by Anthony Thibault on 6/5/2019
//  Copyright 2019 High Fidelity, Inc.
//
//  Distributed under the Apache License, Version 2.0.
//  See the accompanying file LICENSE or http://www.apache.org/licenses/LICENSE-2.0.html
//

#ifndef hifi_FileLoader_h
#define hifi_FileLoader_h

#include <QObject>
#include <QString>

class FileLoader : public QObject {
    Q_OBJECT
public:
    Q_INVOKABLE QString readAll(QString filename);
};

#endif
