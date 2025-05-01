import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Rectangle {
    id: storeTab
    color: "transparent"

    Text {
        anchors.centerIn: parent
        text: "Store Content"
        color: "white"
        font.pixelSize: 24 * mainWindow.scaleFactor
    }
}