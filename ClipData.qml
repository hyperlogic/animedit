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

    function fieldChangedMethod(key, newValue) {
        var ROLE_DATA = 0x0103;

        console.log("AJT: theModel.data()");

        var dataValue = theModel.data(modelIndex, ROLE_DATA);

        console.log("AJT: mutate");

        dataValue[key] = newValue;

        console.log("AJT: thieModel.setData()");

        theModel.setData(modelIndex, dataValue, ROLE_DATA);

        console.log("AJT: field changed, key = " + key + ", value = " + newValue);
    }

    function setIndex(index) {
        modelIndex = index;

        var ROLE_DATA = 0x0103;
        var dataValue = theModel.data(modelIndex, ROLE_DATA);

        // copy dataValue into each field.
        if (dataValue.url) {
            urlField.value = dataValue.url;
        }
        if (dataValue.startFrame) {
            startFrameField.value = dataValue.startFrame;
        }
        if (dataValue.endFrame) {
            endFrameField.value = dataValue.endFrame;
        }
        if (dataValue.timeScale) {
            timeScaleField.value = dataValue.timeScale;
        }
        if (dataValue.loopFlag) {
            loopFlagField.value = dataValue.loopFlag;
        }
        if (dataValue.mirrorFlag) {
            mirrorFlagField.value = dataValue.mirrorFlag;
        }
        if (dataValue.startFrameVar) {
            startFrameVarField.value = dataValue.startFrameVar;
        }
        if (dataValue.endFrameVar) {
            endFrameVarField.value = dataValue.endFrameVar;
        }
        if (dataValue.timeScaleVar) {
            timeScaleVarField.value = dataValue.timeScaleVar;
        }
        if (dataValue.loopFlagVar) {
            loopFlagVarField.value = dataValue.loopFlagVar;
        }
        if (dataValue.mirrorFlagVar) {
            mirrorFlagVarField.value = dataValue.mirrorFlagVar;
        }
    }

    Component.onCompleted: {
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

