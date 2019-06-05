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
    property var json: undefined

    onDataChanged: {
        console.log("DATA changed!")
    }

    Rectangle {
        id: leftHandPane
        color: "#ffffff"
        anchors.fill: parent

        ListModel {
            id: fruitModel
            ListElement {
                name: "First Entry"
                cost: 2.45
            }
            ListElement {
                name: "Second Entry"
                cost: 3.45
            }
            ListElement {
                name: "Third Entry"
                cost: 4.50
            }
        }

        Component {
            id: fruitDelegate
            Row {
                spacing: 10
                Text { text: name }
                Text { text: '$' + cost }
            }
        }

        ListView {
            parent: leftHandPane
            x: 0
            y: 0
            width: 270
            height: 201
            model: fruitModel
            delegate: fruitDelegate
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
            var contents = FileLoader.readAll(cleanPath);
            try {
                root.json = JSON.parse(contents);
            } catch (e) {
                console.log("failed to parse animation json file" + e);
                root.json = undefined;
            }
        }
        onRejected: {
            console.log("Canceled");
        }
    }
}


