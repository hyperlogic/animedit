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
    title: qsTr("Hello World")
    menuBar: appMenuBar
    signal load(string filename)

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
        title: "Please choose a file"
        folder: shortcuts.home
        nameFilters: ["Json files (*.json)"]
        onAccepted: {
            root.activated(fileDialog.fileUrls)
            console.log("You chose: " + fileDialog.fileUrls)
        }
        // onRejected: { console.log("Canceled") }
    }
}
