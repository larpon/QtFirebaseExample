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


PLATFORMS_DIR = $$PWD/platforms

android: {

    ANDROID_PACKAGE_SOURCE_DIR = $$PLATFORMS_DIR/android

    DISTFILES += \
        $$ANDROID_PACKAGE_SOURCE_DIR/AndroidManifest.xml \
        $$ANDROID_PACKAGE_SOURCE_DIR/build.gradle \
        $$ANDROID_PACKAGE_SOURCE_DIR/gradle.properties \
        $$ANDROID_PACKAGE_SOURCE_DIR/local.properties \
        $$ANDROID_PACKAGE_SOURCE_DIR/google-services.json \
        $$ANDROID_PACKAGE_SOURCE_DIR/src/com/blackgrain/android/firebasetest/Main.java \
        $$ANDROID_PACKAGE_SOURCE_DIR/res/values/apptheme.xml \
        $$ANDROID_PACKAGE_SOURCE_DIR/res/values/strings.xml \
        $$ANDROID_PACKAGE_SOURCE_DIR/res/drawable/splash.xml \
        $$ANDROID_PACKAGE_SOURCE_DIR/gradlew \
        $$ANDROID_PACKAGE_SOURCE_DIR/gradlew.bat \
        $$ANDROID_PACKAGE_SOURCE_DIR/gradle/wrapper/gradle-wrapper.jar \
        $$ANDROID_PACKAGE_SOURCE_DIR/gradle/wrapper/gradle-wrapper.properties
}

ios: {
    CONFIG -= bitcode

    ios_icon.files = $$files($$PLATFORMS_DIR/ios/icons/AppIcon*.png)
    QMAKE_BUNDLE_DATA += ios_icon

    itunes_icon.files = $$files($$PLATFORMS_DIR/ios/iTunesArtwork*)
    QMAKE_BUNDLE_DATA += itunes_icon

    app_launch_images.files = $$PLATFORMS_DIR/ios/LauncherScreen.xib $$files($$PLATFORMS_DIR/ios/LaunchImage*.png) $$files($$PLATFORMS_DIR/ios/splash_*.png)
    QMAKE_BUNDLE_DATA += app_launch_images

    QMAKE_INFO_PLIST = $$PLATFORMS_DIR/ios/Info.plist

    DISTFILES += \
        $$PLATFORMS_DIR/ios/Info.plist \
        $$PLATFORMS_DIR/ios/GoogleService-Info.plist

    # You must deploy your Google Play config file
    deployment.files = $$PLATFORMS_DIR/ios/GoogleService-Info.plist
    deployment.path =
    QMAKE_BUNDLE_DATA += deployment

#    Q_ENABLE_BITCODE.name = ENABLE_BITCODE
#    Q_ENABLE_BITCODE.value = NO
#    QMAKE_MAC_XCODE_SETTINGS += Q_ENABLE_BITCODE
}

# Make these modules of QtFirebase
# NOTE QTFIREBASE_SDK_PATH can be symlinked to match $$PWD/firebase_cpp_sdk
QTFIREBASE_CONFIG += analytics messaging admob remote_config auth database

# Disable fixes for know problems
# DEFINES += QTFIREBASE_DISABLE_FIX_ANDROID_AUTO_APP_STATE_VISIBILTY

# Includes QtFirebase:
include(../extensions/QtFirebase/qtfirebase.pri)

RESOURCES += \
    qml.qrc
