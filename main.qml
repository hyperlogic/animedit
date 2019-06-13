import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.6
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0

ApplicationWindow {
    id: root
    visible: true
    width: 640
    height: 480
    color: "#ffffff"
    opacity: 1
    title: qsTr("Hello World")
    menuBar: appMenuBar

    onDataChanged: {
        console.log("DATA changed!")
    }

    SplitView {
        id: splitView
        anchors.fill: parent

        TreeView {
            id: leftHandPane
            width: 300
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            model: theModel
            itemDelegate: TreeDelegate {}

            TableViewColumn {
                role: "name"
                title: "Name"
            }

            TableViewColumn {
                role: "type"
                title: "Type"
            }

            onClicked: {
                console.log("AJT: CLICK " + theModel.data(index, 0x0100 + 1).text);
            }
        }

        Rectangle {
            id: rightHandPane
            color: "#adadad"
            anchors.left: leftHandPane.right
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 0

            Column {
                id: rightHandPaneColumn

                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0

                DataField {}
                DataField {}
                DataField {}
                DataField {}
            }
        }

    }

    MenuBar {
        id: appMenuBar
        Menu {
            title: "File"
            MenuItem {
                text: "Open..."
                onTriggered: fileDialog.open()
            }
            MenuItem { text: "Save" }
        }
    }

    FileDialog {
        id: fileDialog
        title: "Open an animation json file"
        folder: shortcuts.home
        nameFilters: ["Json files (*.json)"]
        onAccepted: {
            var path = fileDialog.fileUrl.toString();
            // remove prefixed "file:///"
            path = path.replace(/^(file:\/{3})/,"");
            // unescape html codes like '%23' for '#'
            var cleanPath = decodeURIComponent(path);
            console.log("You chose: " + cleanPath);
            theModel.loadFromFile(cleanPath);
        }
        onRejected: {
            console.log("Canceled");
        }
    }
}



















/*##^## Designer {
    D{i:2;anchors_width:300}D{i:7;anchors_height:1000;anchors_width:1000}D{i:6;anchors_width:50;anchors_x:0}
}
 ##^##*/
