import QtQuick 2.0
import QtQuick.Controls 1.4

import QtFirebase 1.0

import "qml"

ApplicationWindow {
    id: app

    title: qsTr('%1 (%2x%3)').arg(App.name).arg(width).arg(height)

    visible: true

    width: 500
    height: 832

    property bool paused: !App.active

    color: "#def2da"

    Keys.onBackPressed: back()

    function back() {
        loader.source = ""
    }

    Column {
        anchors {
            horizontalCenter: parent.horizontalCenter
        }

        visible: !loader.ready

        Item {
            width: height
            height: parent.height*0.2
        }

        Image {
            id: logoImage
            source: "assets/logo.png"

            anchors {
                horizontalCenter: parent.horizontalCenter
            }

            transformOrigin: Item.Center
            SequentialAnimation {
                running: true
                loops: Animation.Infinite

                ParallelAnimation {
                    NumberAnimation {
                        target: logoImage
                        property: "scale"
                        duration: 900
                        to: 1.05
                    }
                    NumberAnimation {
                        target: logoImage
                        property: "rotation"
                        duration: 700
                        to: 3
                    }
                }

                ParallelAnimation {
                    NumberAnimation {
                        target: logoImage
                        property: "scale"
                        duration: 900
                        to: 0.95
                    }

                    NumberAnimation {
                        target: logoImage
                        property: "rotation"
                        duration: 700
                        to: -3
                    }
                }
            }
        }

        Item {
            width: height
            height: parent.height*0.05
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "AdMob"
            onClicked: loader.source = "qml/pages/AdMob.qml"
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Analytics"
            onClicked: loader.source = "qml/pages/Analytics.qml"
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Auth"
            onClicked: loader.source = "qml/pages/Auth.qml"
        }


        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Database"
            onClicked: loader.source = "qml/pages/Database.qml"
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Messaging"
            onClicked: loader.source = "qml/pages/Messaging.qml"
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: "Remote Config"
            onClicked: loader.source = "qml/pages/RemoteConfig.qml"
        }

    }


    Row {
        id: bottomRow
        anchors {
            bottom: consoleHistory.top
            left: parent.left
            right: parent.right
        }

        /*
        Button {
            text: "About"
            onClicked: { about.visible = !about.visible  }
        }*/

        Button {
            text: "Console"
            onClicked: { consoleHistory.visible = !consoleHistory.visible }
        }

    }

    Column {
        id: about
        anchors {
            bottom: bottomRow.top
        }

        Label {
            text: "Qt "+App.versions.qt
        }
        Label {
            text: "App "+App.versions.app+" ("+App.versions.git+"/"+App.versions.branch+")"
        }
        Label {
            //text: "QtFirebase "+App.versions.firebase +" ("+App.versions.firebaseGit+"/"+App.versions.firebaseGitBranch+")"
        }
    }

    TextArea {
        id: consoleHistory
        anchors {
            bottom: parent.bottom
            left: parent.left
            right: parent.right
        }
        text: App.consoleHistory

        width: parent.width
        height: visible ? app.height*0.25 : 0
        Behavior on height {
            NumberAnimation { duration: 250 }
        }

        wrapMode: TextEdit.NoWrap
        visible: false
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

        onSourceChanged: {
            if(source.toString() !== "")
            App.debug("Load page",source)
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
            App.log("Banner failed with error code",code,"and message",message)

            // See AdMob.Error* enums
            if(code === AdMob.ErrorNetworkError)
                App.log("No network available");
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
