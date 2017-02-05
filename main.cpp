#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickView>
#include <QtQml>

#include "noisesimulator.h"
#include "mousemover.h"
#include <vendor.h>

int main(int argc, char *argv[])
{
    // Fixes motion problems, see https://bugreports.qt.io/browse/QTBUG-53165
    qputenv("QSG_RENDER_LOOP", "basic");

    qmlRegisterType<NoiseSimulator>("NoiseSimulator", 1, 0, "NoiseSimulator");
    qmlRegisterType<MouseMover>("MouseMover", 1, 0, "MouseMover");
    QApplication app(argc, argv);

    QSurfaceFormat format;
    format.setMajorVersion(3);
    format.setMinorVersion(2);
    format.setProfile(QSurfaceFormat::CoreProfile);
    QSurfaceFormat::setDefaultFormat(format);

    // Application version
    QQmlApplicationEngine engine;
    qpm::init(app, engine);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
