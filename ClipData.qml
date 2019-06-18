import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 1.6
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.0

/*
Rectangle {
    height: 20
    width: 200
    color: "red"
}
*/

Column {
    id: clipDataColumn
    x: 0
    y: 0
    height: 50
    width: 200
    spacing: 6
    property var modelIndex

    signal fieldChanged(string key, var newValue)

    // called by each field when its value is changed.
    function fieldChangedMethod(key, newValue) {
        var ROLE_DATA = 0x0103;
        var dataValue = theModel.data(modelIndex, ROLE_DATA);
        dataValue[key] = newValue;

        // copy the new value into the model.
        theModel.setData(modelIndex, dataValue, ROLE_DATA);
    }

    // called when a new model is loaded
    function setIndex(index) {
        modelIndex = index;

        var ROLE_DATA = 0x0103;
        var dataValue = theModel.data(modelIndex, ROLE_DATA);

        var fields = ["url", "startFrame", "endFrame", "timeScale", "loopFlag", "mirrorFlag",
                      "startFrameVar", "endFrameVar", "timeScaleVar", "loopFlagVar", "mirrorFlagVar"];

        // copy data from theModel into each field.
        var l = fields.length;
        for (var i = 0; i < l; i++) {
            var val = dataValue[fields[i]];
            if (val) {
                clipDataColumn.children[i].value = val;
            }
        }
    }

    Component.onCompleted: {
        // this signal is fired from each data field when values are changed.
        clipDataColumn.fieldChanged.connect(fieldChangedMethod)
    }

    StringField {
        id: urlField
        key: "url"
        value: "qrc:///avatar/animations/idle.fbx"
    }

    NumberField {
        id: startFrameField
        key: "startFrame"
        value: 0.0
    }

    NumberField {
        id: endFrameField
        key: "endFrame"
        value: 0.0
    }

    NumberField {
        id: timeScaleField
        key: "timeScale"
        value: 0.0
    }

    BooleanField {
        id: loopFlagField
        key: "loopFlag"
        value: false
    }

    BooleanField {
        id: mirrorFlagField
        key: "mirrorFlag"
        value: false
        optional: true
    }

    StringField {
        id: startFrameVarField
        key: "startFrameVar"
        value: ""
        optional: true
    }

    StringField {
        id: endFrameVarField
        key: "endFrameVar"
        value: ""
        optional: true
    }

    StringField {
        id: timeScaleVarField
        key: "timeScaleVar"
        value: ""
        optional: true
    }

    StringField {
        id: loopFlagVarField
        key: "loopFlagVar"
        value: ""
        optional: true
    }

    StringField {
        id: mirrorFlagVarField
        key: "mirrorFlagVar"
        value: ""
        optional: true
    }
}

