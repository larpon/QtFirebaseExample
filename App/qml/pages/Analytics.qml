import QtQuick 2.0
import QtQuick.Controls 1.4

import QtFirebase 1.0

import ".."

/*
 * Analytics example
 */
Page {
    id: root

    function getRandomArbitrary(min, max) {
        return Math.random() * (max - min) + min;
    }

    function getRandomInt(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }

    Button {
        anchors { centerIn: parent }

        text: "Test event logging"
        onClicked: {
            App.log("Calling Analytics::logEvent()")

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

}
