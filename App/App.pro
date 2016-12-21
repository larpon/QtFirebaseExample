TEMPLATE = app

QT += gui qml quick multimedia
!no_desktop: QT += widgets

CONFIG += c++11

# Additional import path used to resolve QML modules in Qt Creator's code model
# QML_IMPORT_PATH =

# IMPORTANT must be included before extensions
# Default rules for deployment.
include(deployment.pri)

SOURCES += \
    main.cpp

android: {

    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android

    DISTFILES += \
        $$ANDROID_PACKAGE_SOURCE_DIR/AndroidManifest.xml \
        $$ANDROID_PACKAGE_SOURCE_DIR/build.gradle \
        $$ANDROID_PACKAGE_SOURCE_DIR/gradle.properties \
        $$ANDROID_PACKAGE_SOURCE_DIR/local.properties \
        $$ANDROID_PACKAGE_SOURCE_DIR/google-services.json \
        $$ANDROID_PACKAGE_SOURCE_DIR/src/com/blackgrain/android/firebasetest/Main.java \
        $$ANDROID_PACKAGE_SOURCE_DIR/res/values/apptheme.xml \
        $$ANDROID_PACKAGE_SOURCE_DIR/res/values/strings.xml \
        $$ANDROID_PACKAGE_SOURCE_DIR/res/drawable/splash.xml

}

ios: {

    ios_icon.files = $$files($$PWD/ios/icons/AppIcon*.png)
    QMAKE_BUNDLE_DATA += ios_icon

    itunes_icon.files = $$files($$PWD/ios/iTunesArtwork*)
    QMAKE_BUNDLE_DATA += itunes_icon

    app_launch_images.files = $$PWD/ios/LauncherScreen.xib $$files($$PWD/ios/LaunchImage*.png) $$files($$PWD/ios/splash_*.png)
    QMAKE_BUNDLE_DATA += app_launch_images

    QMAKE_INFO_PLIST = $$PWD/ios/Info.plist

    DISTFILES += \
        ios/Info.plist \
        ios/GoogleService-Info.plist

    # You must deploy your Google Play config file
    deployment.files = ios/GoogleService-Info.plist
    deployment.path =
    QMAKE_BUNDLE_DATA += deployment

#    Q_ENABLE_BITCODE.name = ENABLE_BITCODE
#    Q_ENABLE_BITCODE.value = NO
#    QMAKE_MAC_XCODE_SETTINGS += Q_ENABLE_BITCODE
}

# Make these modules of QtFirebase
QTFIREBASE_CONFIG += analytics admob
# include QtFirebase
include(../extensions/QtFirebase/qtfirebase.pri)

RESOURCES += \
    qml.qrc
