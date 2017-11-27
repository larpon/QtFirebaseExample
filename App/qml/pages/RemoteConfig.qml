import QtQuick 2.0
import QtQuick.Controls 1.4

import QtFirebase 1.0

import ".."

/*
 * RemoteConfig example
 */
Page {
    id: root

    Column {
        anchors.centerIn: parent

        Text{
            id: titleText
            anchors.horizontalCenter: parent.horizontalCenter
            text:"<h2>Remote Config</h2>See console output for some action"
        }
    }

    // Timer to poll for changes in RemoteConfig
    Timer {
        running: true
        repeat: true
        interval: 5 * 60 * 1000 // Poll for changes every 5th minute
        onTriggered: remoteConfig.fetch()
    }

    RemoteConfig {
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
            App.log("RemoteConfig.ready", ready);
            if(ready) {
                App.log("RemoteConfig::fecth()");
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
            App.log("RemoteConfig.parameters")
            App.log("test long", parameters["remote_config_test_long"]);
            App.log("test bool", parameters["remote_config_test_boolean"]);
            App.log("test double", parameters["remote_config_test_double"]);
            App.log("test string", parameters["remote_config_test_string"]);
        }

        //5. Handle errors
        onError: {
            App.error("RemoteConfig error code:" + code + " message:" + message);
        }
    }

}
