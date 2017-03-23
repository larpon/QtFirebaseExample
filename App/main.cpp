#include <QtQml>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    #ifdef QT_DEBUG
        engine.rootContext()->setContextProperty("debugBuild", QVariant(true));
    #else
        engine.rootContext()->setContextProperty("debugBuild", QVariant(false));
    #endif

    engine.addImportPath("qrc:///");

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
