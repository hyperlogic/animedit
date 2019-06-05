#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDebug>
#include "fileloader.h"


/*
#include <QFile>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include <QtGlobal>

QJsonObject loadJSONFile(const QString& filename) {
    QFile file(filename);
    if (!file.exists()) {
        qFatal("loadJSONFile: failed to open file %s", filename.constData());
        return QJsonObject();
    } else if (!file.open(QIODevice::ReadOnly)) {
        qFatal("loadJSONFile: failed to open file %s", filename.constData());
        return QJsonObject();
    } else {
        qDebug("loadJSONFile: success opening file %s", filename.constData());
        QByteArray contents = file.readAll();
        QJsonParseError error;
        auto doc = QJsonDocument::fromJson(contents, &error);
        if (error.error != QJsonParseError::NoError) {
            qFatal("loadJSONFile: failed to parse json, error %s", error.errorString().constData());
            return QJsonObject();
        }
        return doc.object();
    }
}
*/

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // expose FileLoader to qml
    FileLoader fileLoader;
    engine.rootContext()->setContextProperty("FileLoader", &fileLoader);

    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated, &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl) {
            QCoreApplication::exit(-1);
        } else {
            ;
        }
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
