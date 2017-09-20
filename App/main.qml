import QtQuick 2.0
import QtQuick.Controls 1.4

import QtFirebase 1.0

ApplicationWindow {
    id: app

    title: qsTr('QtFirebase Example (%1x%2)').arg(width).arg(height)

    visible: true

    width: 500
    height: 832

    property bool paused: !Qt.application.active

    color: "#def2da"

    Keys.onBackPressed: back()

    function back() {
        loader.source = ""
    }

    Column {
        anchors.centerIn: parent

        visible: !loader.ready

        Label {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Examples"
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "AdMob"
            onClicked: loader.source = "qml/AdMob.qml"
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Analytics"
            onClicked: loader.source = "qml/Analytics.qml"
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Auth"
            onClicked: loader.source = "qml/Auth.qml"
        }


        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Database"
            onClicked: loader.source = "qml/Database.qml"
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Messaging"
            onClicked: loader.source = "qml/Messaging.qml"
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Remote Config"

            property int clicks: 0
            onClicked: {
                clicks++
                loader.source = "qml/RemoteConfig.qml"
                if(clicks >= 2)
                    console.log('Crashing :( - To prevent this place RemoteConfig a place in your code where it\'s not re-initialized')
            }

        }

    }

    Loader {
        id: loader
        anchors { fill: parent }

        property bool ready: status == Loader.Ready

        onReadyChanged: {
            if(ready) {
                item.exit.connect(function(){
                    app.back()
                })
            }
        }
    }

    AdMob {
        appId: Qt.platform.os == "android" ? "ca-app-pub-6606648560678905~6485875670" : "ca-app-pub-6606648560678905~1693919273"

        // NOTE All banners and interstitials will use this list
        // unless they have their own testDevices list specified
        testDevices: [
            "01987FA9D5F5CEC3542F54FB2DDC89F6",
            "d206f9511ffc1bc2c7b6d6e0d0e448cc"
        ]
    }

    Connections {
        target: loader
        onReadyChanged: {
            if(!loader.ready) {
                banner.load()
            }
        }
    }

    AdMobBanner {
        id: banner
        adUnitId: Qt.platform.os == "android" ? "ca-app-pub-3940256099942544/6300978111" : "ca-app-pub-6606648560678905/3170652476"

        visible: loaded && !loader.ready

        width: 320
        height: 50

        onReadyChanged: if(ready) load()

        onLoadedChanged: {
            if(loaded)
                moveTo(AdMobBanner.PositionTopCenter)
        }

        onError: {
            // TODO fix "undefined" arguments
            console.log("Banner failed with error code",code,"and message",message)

            // See AdMob.Error* enums
            if(code === AdMob.ErrorNetworkError)
                console.log("No network available");
        }

        request: AdMobRequest {
            gender: AdMob.GenderMale
            childDirectedTreatment: AdMob.ChildDirectedTreatmentUnknown

            // NOTE remember JS Date months are 0 based
            // 1st of Januray 1980:
            birthday: new Date(1980,0,1)

            keywords: [
                "AdMob",
                "QML",
                "Qt",
                "Fun",
                "Test",
                "Firebase"
            ]

            extras: [
                { "something_extra11": "extra_stuff11" },
                { "something_extra12": "extra_stuff12" }
            ]
        }
    }

}
