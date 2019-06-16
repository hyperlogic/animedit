import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.6
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0

Item {
    Row {
        id: row1
        x: 0
        y: 50
        height: 20
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        Text {
            id: element1
            y: 5
            width: 100
            text: qsTr("Your mom:")
            font.pixelSize: 12
        }

        TextField {
            id: textField1
            x: 100
            width: 200
            text: "POOP"
        }
    }

    Row {
        id: row2
        x: 0
        y: 70
        height: 20
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0

        Text {
            id: element2
            y: 5
            width: 100
            text: qsTr("Your dad:")
            font.pixelSize: 12
        }

        TextField {
            id: textField2
            x: 100
            width: 200
            text: "POOP"
        }
    }
}
