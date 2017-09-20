import QtQuick 2.0
import QtQuick.Controls 1.4

import QtFirebase 1.0

import "."

Page {
    id: root

    Column {
        anchors.centerIn: parent

        Label {
            text: "Token"
        }

        Text {
            width: root.width - 20
            height: root.height * 0.25

            wrapMode: Text.WordWrap
            text: messaging.token === "" ? "Token value for device should appear here" : messaging.token
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
}
