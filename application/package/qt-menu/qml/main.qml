import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

ApplicationWindow {
    id: mainWindow
    width: 1920
    height: 1080
    visible: true
    title: qsTr("Game Library")

    property real scaleFactor: 1

    ListModel {
        id: gamesModel
    }

    property bool isDataLoaded: false

    Image {
        id: backgroundImage
        anchors.fill: parent
        source: "qrc:/bg.jpg"
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        Rectangle { anchors.fill: parent; color: "#80000000" }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 30 * scaleFactor
        spacing: 0

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 50 * scaleFactor
            Layout.leftMargin: 50 * scaleFactor
            Layout.rightMargin: 50 * scaleFactor
            Layout.bottomMargin: 20
            color: "transparent"

            RowLayout {
                anchors.fill: parent

                RowLayout {
                    spacing: 40 * scaleFactor
                    focus: true
                    Repeater {
                        id: tabRepeater
                        model: ["Games", "Store", "Settings"]
                        delegate: Text {
                            id: tabText
                            text: modelData
                            color: tabBar.currentIndex === index ? "white" : "#8f9297"
                            font.pixelSize: 40 * scaleFactor
                            focus: tabBar.currentIndex === index
                            font.underline: tabText.activeFocus

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    tabBar.currentIndex = index
                                    tabText.forceActiveFocus()
                                }
                            }

                            Keys.onLeftPressed: {
                                if (index > 0) {
                                    tabBar.currentIndex--
                                    tabRepeater.itemAt(tabBar.currentIndex).forceActiveFocus()
                                }
                            }

                            Keys.onRightPressed: {
                                if (index < tabRepeater.count - 1) {
                                    tabBar.currentIndex++
                                    tabRepeater.itemAt(tabBar.currentIndex).forceActiveFocus()
                                }
                            }

                            Keys.onDownPressed: {
                                if (tabBar.currentIndex === 0 && isDataLoaded) {
                                    if (gamesLoader.item) {
                                        gamesLoader.item.gameCarousel.forceActiveFocus()
                                    }
                                }
                                if (tabBar.currentIndex === 2 && isDataLoaded) {
                                    if (settingsLoader.item) {
                                        settingsLoader.item.settingsListView.forceActiveFocus()
                                    }
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.alignment: Qt.AlignRight
                    spacing: 40 * scaleFactor

                    Text {
                        id: clockText
                        color: "white"
                        font.pixelSize: 40 * scaleFactor
                        width: 60 * scaleFactor
                        horizontalAlignment: Text.AlignRight
                        Component.onCompleted: {
                            var date = new Date()
                            clockText.text = date.toLocaleTimeString(Qt.locale(), "HH:mm")
                        }
                        Timer {
                            interval: 1000
                            running: true
                            repeat: true
                            onTriggered: {
                                var date = new Date()
                                clockText.text = date.toLocaleTimeString(Qt.locale(), "HH:mm")
                            }
                        }
                    }
                }
            }
        }

        StackLayout {
            id: tabBar
            Layout.fillWidth: true
            Layout.fillHeight: true
            currentIndex: 0

            Loader {
                id: gamesLoader
                source: "qrc:/qml/Games.qml"
                onLoaded: {
                    console.log("Games.qml loaded via Loader")
                    item.gamesModel = gamesModel
                    item.isDataLoaded = Qt.binding(function() { return mainWindow.isDataLoaded })
                }
            }

            Loader {
                id: storeLoader
                source: "qrc:/qml/Store.qml"
                onLoaded: {
                    console.log("Store.qml loaded via Loader")
                }
            }

            Loader {
                id: settingsLoader
                source: "qrc:/qml/Settings.qml"
                onLoaded: {
                    console.log("Settings.qml loaded via Loader")
                }
            }
        }
    }

    Shortcut {
        sequence: "Q"
        onActivated: {
            if (tabBar.currentIndex > 0) {
                tabBar.currentIndex--
                tabRepeater.itemAt(tabBar.currentIndex).forceActiveFocus()
            }
        }
    }

    Shortcut {
        sequence: "E"
        onActivated: {
            if (tabBar.currentIndex < 2) {
                tabBar.currentIndex++
                tabRepeater.itemAt(tabBar.currentIndex).forceActiveFocus()
            }
        }
    }

    Component.onCompleted: {
        jsonReader.readJsonFile("qrc:/installedGames.json")
        tabRepeater.itemAt(0).forceActiveFocus()
    }

    Connections {
        target: jsonReader
        function onJsonDataReady(games) {
            for (var i = 0; i < games.length; i++) {
                gamesModel.append(games[i])
            }
            isDataLoaded = true
            gamesLoader.item.gameCarousel.forceActiveFocus() 
        }
        function onDataLoadedChanged() {
            if (!jsonReader.dataLoaded) {
                console.log("Error loading JSON data");
                isDataLoaded = false
            }
        }
    }
}