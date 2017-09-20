import QtQuick 2.0
import QtQuick.Controls 1.4

import QtFirebase 1.0

Item {
    id: root

    anchors { fill: parent }

    signal exit

    Button {
        anchors {
            top: parent.top
            left: parent.left
            margins: 20
        }

        text: "<- go back"
        onClicked: exit()
    }
}
