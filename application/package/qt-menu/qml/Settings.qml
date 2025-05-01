import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Rectangle {
    id: settingsTab
    color: "transparent"

    property alias settingsListView: settingsList

    RowLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            Layout.preferredWidth: parent.width * 0.25
            Layout.fillHeight: true
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 10

                ListView {
                    id: categoriesList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    focus: true
                    highlightMoveDuration: 200

                    model: ListModel {
                        ListElement { name: "Account Information"; description: "Manage your account details and preferences." }
                        ListElement { name: "Network Settings"; description: "Configure your internet connection and network options." }
                        ListElement { name: "Graphics Settings"; description: "Adjust display and graphics preferences for optimal performance." }
                        ListElement { name: "System and Firmware"; description: "Manage system updates and firmware settings." }
                    }

                    delegate: Rectangle {
                        width: parent.width
                        height: 60
                        color: categoriesList.currentIndex === index ? "white" : "transparent"
                        radius: 10

                        Text {
                            anchors.left: parent.left
                            anchors.leftMargin: 20
                            anchors.verticalCenter: parent.verticalCenter
                            text: name
                            color: categoriesList.currentIndex === index ? "black" : "white"
                            font.pixelSize: 26
                            elide: Text.ElideRight
                            width: parent.width - 40
                        }

                        Behavior on color { ColorAnimation { duration: 200 } }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                categoriesList.currentIndex = index
                                forceActiveFocus()
                            }
                        }

                        Keys.onUpPressed: {
                            if (index > 0) categoriesList.decrementCurrentIndex()
                        }
                        Keys.onDownPressed: {
                            if (index < categoriesList.count - 1) categoriesList.incrementCurrentIndex()
                        }
                        Keys.onRightPressed: settingsList.forceActiveFocus()
                        Keys.onReturnPressed: console.log("Selected category:", name)
                    }
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: 1
            Layout.preferredHeight: parent.height * 0.95
            color: "#444444"
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 40
                spacing: 30

                Text {
                    Layout.fillWidth: true
                    text: categoriesList.currentItem ? categoriesList.model.get(categoriesList.currentIndex).description : ""
                    color: "#cccccc"
                    font.pixelSize: 26
                    wrapMode: Text.WordWrap
                }

                ListView {
                    id: settingsList
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    focus: false
                    highlightMoveDuration: 200

                    model: ListModel {
                        id: settingsModel
                    }

                    delegate: Item {
                        width: settingsList.width
                        height: 60

                        Row {
                            anchors.fill: parent
                            spacing: 20

                            Text {
                                width: parent.width * 0.25
                                text: name
                                color: "white"
                                font.pixelSize: 30
                                font.weight: Font.Bold
                                elide: Text.ElideRight
                            }

                            Text {
                                width: parent.width * 0.7
                                text: value
                                color: "#cccccc"
                                font.pixelSize: 30
                                elide: Text.ElideRight
                            }

                            Rectangle {
                                width: 1
                                height: 20
                                color: "#444444"
                            }
                        }
                    }

                    Connections {
                        target: categoriesList
                        function onCurrentIndexChanged() {
                            settingsModel.clear()
                            switch (categoriesList.currentIndex) {
                            case 0:
                                settingsModel.append({ name: "Username", value: "PlayerOne" })
                                settingsModel.append({ name: "Email", value: "playerone@example.com" })
                                settingsModel.append({ name: "Two-Factor Auth", value: "Enabled" })
                                break
                            case 1:
                                settingsModel.append({ name: "Connection Type", value: "Wi-Fi" })
                                settingsModel.append({ name: "IP Address", value: systemSettings.ipAddress })
                                settingsModel.append({ name: "Network Status", value: systemSettings.networkStatus })
                                break
                            case 2:
                                settingsModel.append({ name: "Resolution", value: "4K" })
                                settingsModel.append({ name: "Frame Rate", value: "60 FPS" })
                                settingsModel.append({ name: "Ray Tracing", value: "On" })
                                break
                            case 3:
                                settingsModel.append({ name: "System Version", value: "5.02" })
                                settingsModel.append({ name: "Firmware Update", value: "Up to Date" })
                                settingsModel.append({ name: "Storage Available", value: "250 GB" })
                                break
                            }
                        }
                    }

                    Keys.onLeftPressed: categoriesList.forceActiveFocus()
                    Keys.onUpPressed: {
                        if (currentIndex > 0) decrementCurrentIndex()
                    }
                    Keys.onDownPressed: {
                        if (currentIndex < count - 1) incrementCurrentIndex()
                    }
                    Keys.onReturnPressed: console.log("Selected setting:", settingsModel.get(currentIndex).name)
                }
            }
        }
    }
}