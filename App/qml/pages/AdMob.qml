import QtQuick 2.0
import QtQuick.Controls 2.0

import QtFirebase 1.0

import ".."

/*
 * AdMob example
 */
Page {
    id: root

    function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    Column {
        anchors.centerIn: parent

        Row {

            Button {
                enabled: interstitial.loaded
                text: enabled ? "Show interstitial" : "Interstitial loading..."
                onClicked: interstitial.show()
            }
            Button {
                visible: !interstitial.loaded
                text: "Reload"
                onClicked: interstitial.load()
            }
        }

        Row {
            Button {
                enabled: rewardedVideoAd.loaded
                text: enabled ? "Show Rewarded Video Ad" : "Rewarded Video Ad loading..."
                onClicked: rewardedVideoAd.show()
            }
            Button {
                visible: !rewardedVideoAd.loaded
                text: "Reload"
                onClicked: rewardedVideoAd.load()
            }
        }

        Row {
            Button {
                enabled: banner.loaded
                text: banner.loaded ? banner.visible ? "Hide banner" : "Show banner" : "Banner loading..."
                onClicked: banner.visible = !banner.visible
            }
            Button {
                visible: !banner.loaded
                text: "Reload"
                onClicked: banner.load()
            }
        }


        Button {
            enabled: banner.loaded
            text: "Move banner to random position"
            onClicked: {
                // NOTE that the banner won't leave screen on Android (or crash depending on Firebase SDK version) - even if you set off-screen coordinates.
                // On iOS you can set the banner off-screen
                // This is not a "feature" of QtFirebase
                var rx = getRandomInt(0, root.width-banner.width)
                var ry = getRandomInt(0, root.height-banner.height)

                banner.x = rx
                banner.y = ry
            }
        }

    }

    // NOTE a size of 320x50 will give a Standard banner - other sizes will give a SmartBanner
    // NOTE width and height are values relative to the native screen size - NOT any parent QML components
    AdMobBanner {
        id: banner
        adUnitId: Qt.platform.os == "android" ? "ca-app-pub-6606648560678905/2662933118" : "ca-app-pub-6606648560678905/6382686274"

        visible: loaded

        width: 320
        height: 50

        onReadyChanged: if(ready) load()

        onLoadedChanged: {
            if(loaded)
                moveTo(AdMobBanner.PositionBottomCenter)
        }

        onError: {
            App.log("Banner failed with error code",code,"and message",message)

            // See AdMob.Error* enums
            if(code === AdMob.ErrorNetworkError)
                App.log("No network available");
        }

        request: AdMobRequest {
            gender: AdMobRequest.GenderFemale
            //childDirectedTreatment: AdMobRequest.ChildDirectedTreatmentUnknown

            // NOTE remember JS Date months are 0 based
            // 1st of Januray 1980:

            birthday: new Date(1990,0,1)

            testDevices: [
                "6CFCACF9CB1F59428D60EFEDF19BD967"
            ]

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
            gender: AdMobRequest.GenderFemale
            childDirectedTreatment: AdMobRequest.ChildDirectedTreatmentTagged

            // NOTE remember JS Date months are 0 based
            // 8th of December 1979:
            birthday: new Date(1979,11,8)

            testDevices: [
                "6CFCACF9CB1F59428D60EFEDF19BD967"
            ]

            keywords: [
                "Perfume",
                "Game",
                "Scent"
            ]

            extras: [
                { "something_extra1": "extra_stuff1" },
                { "something_extra2": "extra_stuff2" }
            ]
        }

        onError: {
            App.log("AdMobInterstitial","::onError","Interstitial failed with error code",code,"and message",message)

            // See AdMob.Error* enums
            if(code === AdMob.ErrorNone)
                App.log("AdMobInterstitial","::onError","No error - this shouldn't display :)")
            if(code === AdMob.ErrorAlreadyInitialized)
                App.log("AdMobInterstitial","::onError","Already initialized")
            if(code === AdMob.ErrorInternalError)
                App.log("AdMobInterstitial","::onError","Internal error")
            if(code === AdMob.ErrorInvalidRequest)
                App.log("AdMobInterstitial","::onError","Invalid request")
            if(code === AdMob.ErrorLoadInProgress)
                App.log("AdMobInterstitial","::onError","Load in progress")
            if(code === AdMob.ErrorNetworkError)
                App.log("AdMobInterstitial","::onError","No network available")
            if(code === AdMob.ErrorNoFill)
                App.log("AdMobInterstitial","::onError","No fill")
            if(code === AdMob.ErrorNoWindowToken)
                App.log("AdMobInterstitial","::onError","No window token")
            if(code === AdMob.ErrorUninitialized)
                App.log("AdMobInterstitial","::onError","Uninitialized")
            if(code === AdMob.ErrorUnknown)
                App.log("AdMobInterstitial","::onError","Unknown error")
        }

        onPresentationStateChanged: {
            if(state === AdMobInterstitial.PresentationStateHidden)
                App.log("AdMobInterstitial","::onPresentationStateChanged","PresentationStateHidden")
            if(state === AdMobInterstitial.PresentationStateCoveringUI)
                App.log("AdMobInterstitial","::onPresentationStateChanged","PresentationStateCoveringUI");
        }
    }

    AdMobRewardedVideoAd {
        id: rewardedVideoAd

        adUnitId: Qt.platform.os == "android" ? "ca-app-pub-6606648560678905/5628948780" : "ca-app-pub-6606648560678905/2850564595"

        onReadyChanged: if(ready) load()
        //onLoadedChanged: if(loaded) show()

        onClosed: load()

        request: AdMobRequest {
            gender: AdMobRequest.GenderUnknown
            childDirectedTreatment: AdMobRequest.ChildDirectedTreatmentUnknown

            testDevices: [
                "6CFCACF9CB1F59428D60EFEDF19BD967"
            ]
            // NOTE remember JS Date months are 0 based
            // 8th of December 1979:
            birthday: new Date(1979,11,8)

            keywords: [
                "Qt",
                "Game",
                "Firebase"
            ]

            extras: [
                { "something_extra1": "extra_stuff1" },
                { "something_extra2": "extra_stuff2" }
            ]
        }

        onError: {
            App.log("RewardedVideoAd failed with error code",code,"and message",message)

            // See AdMob.Error* enums
            if(code === AdMob.ErrorNetworkError)
                App.log("No network available");
        }

        onPresentationStateChanged: {
            if(state === AdMobRewardedVideoAd.PresentationStateHidden)
                App.log("AdMobRewardedVideoAd","::onPresentationStateChanged","PresentationStateHidden")
            if(state === AdMobRewardedVideoAd.PresentationStateCoveringUI)
                App.log("AdMobRewardedVideoAd","::onPresentationStateChanged","PresentationStateCoveringUI");
        }
    }

}
