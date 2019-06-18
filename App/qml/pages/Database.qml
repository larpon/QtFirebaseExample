import QtQuick 2.0
import QtQuick.Controls 2.0

import QtFirebase 1.0

import ".."

Page {
    id: root

    /*
     * Database example
     */
    Column {
        anchors { centerIn: parent }

        Connections {
            target: Database
            onReadyChanged: {
                App.debug("Database.ready", Database.ready);
            }
        }

        Item {
            id: json
            property var jsonData0: {
                "test": 99
            }

            property var jsonData: {
                "test": {
                    "FirstName": "John",
                    "LastName": "Doe",
                    "Age": 43,
                    "Address": {
                        "Street": "Downing Street 10",
                        "City": "London",
                        "Country": "Great Britain"
                    },
                    "Phone numbers": [
                        "+44 1234567",
                        "+44 2345678"
                    ]
                }
            }
        }

        Column {
            id: buttonsDatabase

            Button {
                DatabaseRequest {
                    id: setRequest
                    property string requestName: "Set"
                    onCompleted: {
                        if(success) {
                            App.log(requestName+" request completed successfully");
                        } else {
                            App.error(requestName+ " request failed with error:"+errorId()+" "+errorMsg());
                        }

                    }
                }
                enabled: !setRequest.running
                text: setRequest.running ? "running..." : "Set"
                onClicked: {
                    setRequest.child("test").setValue(12345);
                }
            }
            Button {
                DatabaseRequest {
                    id: updateRequest
                    property string requestName: "Update"
                    onCompleted: {
                        if(success) {
                            App.log(requestName+" request completed successfully");
                        } else {
                            App.error(requestName+ " request failed with error:"+errorId()+" "+errorMsg());
                        }

                    }
                }
                enabled: !updateRequest.running
                text: updateRequest.running ? "running..." : "Update"
                onClicked: {
                    updateRequest.updateTree(JSON.stringify(json.jsonData));
                }
            }

            Button {

                DatabaseRequest {
                    id: getRequest
                    property var data;
                    onCompleted: {
                        if(success) {
                            App.log("Get request successfully");
                            if(snapshot.hasChildren()) {
                                App.log(snapshot.key()+" "+snapshot.jsonString())
                                data = JSON.parse(snapshot.jsonString());
                                App.log("Age:"+data.Age);
                            } else {
                                App.log(snapshot.key() +" "+snapshot.value());
                            }
                        } else {
                            App.error("Get request failed with error:"+errorId()+" "+errorMsg());
                        }
                    }
                }
                enabled: !getRequest.running
                text: getRequest.running ? "running..." : "Get"
                onClicked: {
                    getRequest.child("test").exec();
                }
            }
            Button {
                DatabaseRequest {
                    id: pushRequest
                    property string requestName: "Push"
                    onCompleted: {
                        if(success) {
                            App.log(requestName+" request completed successfully");
                            App.log("Pushed child got key:"+childKey())
                        } else {
                            App.error(requestName + " request failed with error:"+errorId()+" "+errorMsg());
                        }
                    }
                }
                enabled: !pushRequest.running
                text: pushRequest.running ? "running..." : "Push"
                onClicked: {
                    pushRequest.child("test").pushChild("pushedChild").setValue(887)
                }
            }

            Button {

                DatabaseRequest {
                    id: query
                    property string requestName: "Query"
                    onCompleted: {
                        if(success) {
                            App.log(requestName+" request completed successfully");
                            if(snapshot.hasChildren()) {
                                App.log(snapshot.key()+" "+snapshot.jsonString())
                            } else {
                                App.log(snapshot.key() +" "+snapshot.value());
                            }
                        } else {
                            App.error(requestName + " request failed with error:"+errorId()+" "+errorMsg());
                        }
                    }
                }
                enabled: !query.running
                text: query.running ? "running..." : "Query"
                onClicked: {
                    //query.child("test").orderByValue().startAt(0).endAt(7).exec()
                    //query.child("ratings").orderByValue().exec()
                    //query.child("ratings").orderByValue().exec()
                    //query.child("ratings").orderByValue().startAt(7).exec()
                    query.child("listtest").exec()
                }
            }
        }
    }
}
