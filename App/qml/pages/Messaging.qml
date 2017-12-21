import QtQuick 2.0
import QtQuick.Controls 1.4

import QtFirebase 1.0

import ".."

Page {
    id: root

    QtObject {
        id: request

        function send() {
            var http = new XMLHttpRequest()
            var url = "http://blackgrain.dk/php/qtfirebase/"
            var params = "device="+messaging.token
            http.open("GET", url+"?"+params, true);
            http.onreadystatechange = function() {
                if(http.readyState == 4 && http.status == 200) {
                    App.log(http.responseText)
                }
            }
            http.send(null)
        }
    }

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

        Column {
            Row {
                Button {
                    text: "Send test message"
                    onClicked: {
                        App.log("Sending in "+messageDelay.text+"seconds")
                        App.setTimeout(function(){
                            request.send()
                        },parseInt(messageDelay.text)*1000)
                    }
                }
            }

            Row {
                Label {
                    text: "Delay"
                }

                TextField {
                    id: messageDelay
                    text: "10"
                    maximumLength: 2
                    width: 40
                }

                Text {
                    text: "seconds"
                }

            }
        }
    }

    Messaging {
        id: messaging

        onReadyChanged: {
            App.log("Messaging.ready", ready)
        }
        onTokenChanged: {
            App.log("Messaging.token", token)
        }
        onDataChanged: {
            App.log("Messaging.data", JSON.stringify(data))
        }
        onMessageReceived: {
            App.log("onMessageReceived","Messaging.data", JSON.stringify(data))
        }

    }
}
