#include <QtQml>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlApplicationEngine>

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;


    #ifdef VERSION
    engine.rootContext()->setContextProperty("version", QString(VERSION));
    #endif

    #ifdef GIT_VERSION
    engine.rootContext()->setContextProperty("gitVersion", QString(GIT_VERSION));
    #endif

    #ifdef GIT_BRANCH
    engine.rootContext()->setContextProperty("gitBranch", QString(GIT_BRANCH));
    #endif

    #ifdef QTFIREBASE_VERSION
    engine.rootContext()->setContextProperty("qtFirebaseVersion", QString(QTFIREBASE_VERSION));
    #endif

    #ifdef QTFIREBASE_GIT_VERSION
    engine.rootContext()->setContextProperty("qtFirebaseGitVersion", QString(QTFIREBASE_GIT_VERSION));
    #endif

    #ifdef QTFIREBASE_GIT_BRANCH
    engine.rootContext()->setContextProperty("qtFirebaseGitBranch", QString(QTFIREBASE_GIT_BRANCH));
    #endif

    #ifdef QT_DEBUG
        engine.rootContext()->setContextProperty("debugBuild", QVariant(true));
    #else
        engine.rootContext()->setContextProperty("debugBuild", QVariant(false));
    #endif

    engine.rootContext()->setContextProperty("qtVersion", QString(QT_VERSION_STR));

    engine.addImportPath("qrc:///");

    engine.load(QUrl(QStringLiteral("qrc:///main.qml")));

    return app.exec();
}
