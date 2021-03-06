#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

#include "treemodel.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    // expose model
    TreeModel model;
    engine.rootContext()->setContextProperty("theModel", &model);

    const QUrl url(QStringLiteral("qrc:/qml/main.qml"));
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
