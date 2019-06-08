import QtQuick 2.0
import animedit.highfidelity.com 1.0

Item {
    Text {
        anchors.fill: parent
        color: styleData.textColor
        elide: styleData.elideMode
        text: styleData.value.text
    }
}
