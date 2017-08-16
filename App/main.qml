import QtQuick 2.0
import QtQuick.Controls 1.4

import QtFirebase 1.0

ApplicationWindow {
    id: application

    title: qsTr('QtFirebase Example (%1x%2)').arg(width).arg(height)

    visible: true

    width: 500
    height: 832

    property bool paused: !Qt.application.active

    /*
     * AdMob example
     */
    AdMob {
        appId: Qt.platform.os == "android" ? "ca-app-pub-6606648560678905~6485875670" : "ca-app-pub-6606648560678905~1693919273"

        // NOTE All banners and interstitials will use this list
        // unless they have their own testDevices list specified
        testDevices: [
            "01987FA9D5F5CEC3542F54FB2DDC89F6",
            "d206f9511ffc1bc2c7b6d6e0d0e448cc"
        ]
    }

    // NOTE a size of 320x50 will give a Standard banner - other sizes will give a SmartBanner
    // NOTE width and height are values relative to the native screen size - NOT any parent QML components
    AdMobBanner {
        id: banner
        adUnitId: Qt.platform.os == "android" ? "ca-app-pub-3940256099942544/6300978111" : "ca-app-pub-6606648560678905/3170652476"

        x: 0
        y: ready ? 10 : 0

        visible: loaded

        width: 320
        height: 50

        onReadyChanged: if(ready) load()

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

    AdMobInterstitial {
        id: interstitial
        adUnitId: Qt.platform.os == "android" ? "ca-app-pub-6606648560678905/3118450073" : "ca-app-pub-6606648560678905/7548649672"
        //adUnitId: "ca-app-pub-6606648560678905/3118450073"; // Android
        //adUnitId: "ca-app-pub-6606648560678905/7548649672"; // iOS

        onReadyChanged: if(ready) load()
        //onLoadedChanged: if(loaded) show()

        onClosed: load()

        request: AdMobRequest {
            gender: AdMob.GenderFemale
            childDirectedTreatment: AdMob.ChildDirectedTreatmentTagged

            // NOTE remember JS Date months are 0 based
            // 8th of December 1979:
            birthday: new Date(1979,11,8)

            keywords: [
                "Perfume",
                "Scent"
            ]

            extras: [
                { "something_extra1": "extra_stuff1" },
                { "something_extra2": "extra_stuff2" }
            ]
        }

        onError: {
            console.log("Interstitial failed with error code",code,"and message",message)
            // See AdMob.Error* enums
            if(code === AdMob.ErrorNetworkError)
                console.log("No network available");
        }
    }


    /*
     * Analytics example
     */
    Analytics {
        id: analytics

        // Analytics collection enabled
        enabled: true

        // App needs to be open at least 1s before logging a valid session
        minimumSessionDuration: 1000
        // App session times out after 5s (5 seconds = 5000 milliseconds)
        sessionTimeout: 5000

        // Set the user ID:
        // NOTE the user id can't be more than 36 chars long
        //userId: "A_VERY_VERY_VERY_VERY_VERY_VERY_LONG_USER_ID_WILL_BE_TRUNCATED"
        userId: "qtfirebase_test_user"
        // or call setUserId()

        // Unset the user ID:
        // userId: "" or call "unsetUserId()"

        // Set user properties:
        // Max 25 properties allowed by Google
        // See https://firebase.google.com/docs/analytics/cpp/properties
        userProperties: [
            { "sign_up_method" : "Google" },
            { "qtfirebase_power_user" : "yes" },
            { "qtfirebase_custom_property" : "test_value" }
        ]
        // or call setUserProperty()

        onReadyChanged: {
            // See: https://firebase.google.com/docs/analytics/cpp/events
            analytics.logEvent("qtfb_ready_event")
            analytics.logEvent("qtfb_ready_event","string_test","string")
            analytics.logEvent("qtfb_ready_event","int_test",getRandomInt(-100, 100))
            analytics.logEvent("qtfb_ready_event","double_test",getRandomArbitrary(-2.1, 2.7))

            analytics.logEvent("qtfb_ready_event_bundle",{
                'key_one': 'value',
                'key_two': 14,
                'key_three': 2.3
            })
        }
    }

    /*
     * RemoteConfig example
     */

    // Timer to poll for changes in RemoteConfig
    Timer {
        running: true
        repeat: true
        interval: 5 * 60 * 1000 // Poll for changes every 5th minute
        onTriggered: remoteConfig.fetch()
    }

    RemoteConfig{
        id: remoteConfig

        // 1. Initialize parameters you would like to fetch from server and their default values
        parameters: {
            "remote_config_test_long": 1,
            "remote_config_test_boolean": false,
            "remote_config_test_double": 3.14,
            "remote_config_test_string": "Default string",
        }

        // 2. Set cache expiration time in milliseconds, see step 3 for details about cache
        cacheExpirationTime: 12*3600*1000 // 12 hours in milliseconds (suggested as default in firebase)

        // 3. When remote config properly initialized request data from server
        onReadyChanged: {
            console.log("RemoteConfig ready changed:"+ready);
            if(ready) {
                remoteConfig.fetch();
                // If the data in the cache was fetched no longer than cacheExpirationTime ago,
                // this method will return the cached data. If not, a fetch from the
                // Remote Config Server will be attempted.
                // If you need to get data urgent use fetchNow(), it is equal to fetch() call with cacheExpirationTime=0
                //
                // IMPORTANT NOTE
                // Be careful with urgent requests, too often requests will result in server throthling
                // which means it will refuse connections for some time
            }
        }

        // 4. If data was retrieved (both from server or cache) the handler will be called
        // you can access data by accessing the "parameters" member variable
        onParametersChanged: {
            console.log("RemoteConfig test long", parameters["remote_config_test_long"]);
            console.log("RemoteConfig test bool", parameters["remote_config_test_boolean"]);
            console.log("RemoteConfig test double", parameters["remote_config_test_double"]);
            console.log("RemoteConfig test string", parameters["remote_config_test_string"]);
        }

        //5. Handle errors
        onError: {
            console.log("RemoteConfig error code:" + code + " message:" + message);
        }
    }

    Messaging {
        id: messaging

        onReadyChanged: {
            console.log("Messaging onReadyChanged", ready)
        }
        onTokenChanged: {
            console.log("Messaging onTokenChanged", token)
        }
        onDataChanged: {
            console.log("Messaging onDataChanged", JSON.stringify(data))
        }
    }

    function getRandomArbitrary(min, max) {
        return Math.random() * (max - min) + min;
    }

    function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    Column {
        anchors.centerIn: parent
        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: interstitial.loaded
            text: enabled ? "Show interstitial" : "Interstitial loading..."
            onClicked: interstitial.show()
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            text: banner.visible ? "Hide banner" : "Show banner"
            onClicked: banner.visible = !banner.visible
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: banner.loaded
            text: "Move banner to random position"
            onClicked: {
                // NOTE that the banner won't leave screen on Android. Even if you set off-screen coordinates.
                // On iOS you can set the banner off-screen
                // This is not a "feature" of QtFirebase
                banner.x = getRandomInt(-banner.width+20, banner.width-20)
                banner.y = getRandomInt(-banner.height+20, application.height+banner.height-20)
            }
        }

        Button {
            anchors.horizontalCenter: parent.horizontalCenter

            text: "Test event logging"
            onClicked: {
                analytics.logEvent("qtfb_event")
                analytics.logEvent("qtfb_event","string_test","string")
                analytics.logEvent("qtfb_event","int_test",getRandomInt(-100, 100))
                analytics.logEvent("qtfb_event","double_test",getRandomArbitrary(-2.1, 2.7))

                analytics.logEvent("qtfb_event_bundle",{
                    'key_one': 'value',
                    'key_two': 14,
                    'key_three': 2.3
                })
            }
        }
    }

}
