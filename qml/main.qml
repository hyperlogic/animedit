import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.6
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0
import "fields"
import "nodes"

ApplicationWindow {
    id: root
    visible: true
    width: 1024
    height: 480
    color: "#ffffff"
    opacity: 1
    title: qsTr("AnimEdit")
    menuBar: appMenuBar

    SplitView {
        id: splitView
        anchors.fill: parent

        TreeView {
            id: leftHandPane
            width: 700
            anchors.bottom: parent.bottom
            anchors.left: parent.left
            anchors.top: parent.top
            model: theModel
            itemDelegate: TreeDelegate {}

            TableViewColumn {
                role: "name"
                title: "Name"
                width: 500
            }

            TableViewColumn {
                role: "type"
                title: "Type"
            }

            onClicked: {
                rightHandPane.setIndex(index);
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

            function createCustomData(qml, index) {
                var component = Qt.createComponent(qml, Component.PreferSynchronous);
                if (component.status === Component.Ready) {
                    var obj = component.createObject(rightHandPaneColumn);
                    obj.setIndex(index);
                } else if (component.status === Component.Error) {
                    console.log("ERROR: " + component.errorString());
                } else if (component.status === Component.Loading) {
                    console.log("ERROR: NOT READY");
                }
            }

            function setIndex(index) {
                var ROLE_NAME = 0x0101;
                var ROLE_TYPE = 0x0102;
                var ROLE_DATA = 0x0103;

                var idValue = theModel.data(index, ROLE_NAME);
                var typeValue = theModel.data(index, ROLE_TYPE);

                idField.theValue = idValue;
                typeField.theValue = typeValue;

                // delete previous custom data obj, if present
                var orig = rightHandPaneColumn.children[2];
                if (orig) {
                    orig.destroy();
                }

                if (typeValue === "clip") {
                    createCustomData("nodes/ClipData.qml", index);
                } else if (typeValue === "blendLinear") {
                    createCustomData("nodes/BlendLinear.qml", index);
                } else if (typeValue === "blendLinearMove") {
                    createCustomData("nodes/BlendLinearMove.qml", index);
                } else if (typeValue === "overlay") {
                    createCustomData("nodes/Overlay.qml", index);
                } else if (typeValue === "stateMachine") {
                    createCustomData("nodes/StateMachine.qml", index);
                } else if (typeValue === "randomSwitchStateMachine") {
                    createCustomData("nodes/RandomStateMachine.qml", index);
                } else if (typeValue === "inverseKinematics") {
                    createCustomData("nodes/InverseKinematics.qml", index);
                }
            }

            Column {
                id: rightHandPaneColumn

                anchors.right: parent.right
                anchors.rightMargin: 0
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: parent.top
                anchors.topMargin: 0

                spacing: 6

                IdField {
                    id: idField
                }

                TypeField {
                    id: typeField
                }
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
