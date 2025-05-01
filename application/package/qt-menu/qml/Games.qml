import QtQuick
import QtQuick.Controls
import QtQuick.Controls.Material
import QtQuick.Layouts

Rectangle {
    id: gamesTab
    color: "transparent"

    property alias gameCarousel: gameCarousel
    property ListModel gamesModel: null
    property bool isDataLoaded: false

    Component.onCompleted: {
        console.log("Games.qml initialized, gamesModel:", gamesModel ? "available" : "null")
        console.log("isDataLoaded:", isDataLoaded)
        if (isDataLoaded && gamesModel && gamesModel.count > 0) {
            gameCarousel.currentIndex = 0
            gameCarousel.forceActiveFocus()
        }
    }

    Connections {
        target: gamesModel
        function onDataChanged() {
            console.log("gamesModel updated, count:", gamesModel ? gamesModel.count : "null")
        }
    }

    Connections {
        target: gamesTab
        function onIsDataLoadedChanged() {
            console.log("isDataLoaded changed to:", isDataLoaded)
            if (isDataLoaded && gamesModel && gamesModel.count > 0) {
                gameCarousel.currentIndex = 0
                gameCarousel.forceActiveFocus()
                console.log("Focused first item in gameCarousel")
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20 * mainWindow.scaleFactor
        spacing: 10 * mainWindow.scaleFactor

        Rectangle {
            Layout.fillWidth: true
            color: "transparent"

            ListView {
                id: gameCarousel
                anchors.fill: parent
                orientation: ListView.Horizontal
                snapMode: ListView.SnapOneItem
                highlightRangeMode: ListView.StrictlyEnforceRange
                preferredHighlightBegin: 0
                preferredHighlightEnd: width * 0.5 + (150 * mainWindow.scaleFactor) * 0.5
                highlightMoveDuration: 400
                model: gamesModel
                clip: false
                keyNavigationWraps: true
                visible: isDataLoaded
                spacing: 20 * mainWindow.scaleFactor

                onCurrentIndexChanged: {
                    if (currentItem) {
                        currentItem.forceActiveFocus()
                        console.log("Current game index:", currentIndex)
                    }
                }

                delegate: Item {
                    width: 200 * mainWindow.scaleFactor
                    height: 300 * mainWindow.scaleFactor
                    focus: true

                    Component.onCompleted: {
                        console.log("Delegate for index:", index, "Name:", gamesModel.get(index).name, "Image:", gamesModel.get(index).featuredImage)
                    }

                    readonly property bool isFullyVisible: {
                        var itemPos = mapToItem(gameCarousel.contentItem, 0, 0).x
                        return itemPos >= 0 && itemPos + width <= gameCarousel.width
                    }

                    Column {
                        anchors.fill: parent
                        opacity: isFullyVisible || (index === 0 && gameCarousel.contentX <= 0) ? 1.0 : 0.5
                        Behavior on opacity { NumberAnimation { duration: 200 } }

                        Rectangle {
                            id: gameCard
                            width: 200 * mainWindow.scaleFactor
                            height: index === gameCarousel.currentIndex ? 300 * mainWindow.scaleFactor : 200 * mainWindow.scaleFactor
                            color: ListView.isCurrentItem ? "#2a2f3d" : "#1e2433"
                            radius: 10 * mainWindow.scaleFactor
                            scale: ListView.isCurrentItem ? 1.4 : 0.9

                            Image {
                                id: featuredImage
                                anchors.fill: parent
                                anchors.margins: 2 * scaleFactor
                                source: "qrc:/" + gamesModel.get(index).featuredImage
                                fillMode: Image.PreserveAspectCrop
                                asynchronous: true
                                layer.enabled: true
                            }

                            Rectangle {
                                anchors.fill: parent
                                anchors.margins: -2 * scaleFactor
                                color: "transparent"
                                border.color: gameCard.activeFocus ? "#4f9eee" : "transparent"
                                border.width: 3 * scaleFactor
                                radius: 12 * scaleFactor
                                z: -1
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    gameCarousel.currentIndex = index
                                    gameCard.forceActiveFocus()
                                }
                            }

                            Keys.onLeftPressed: {
                                if (gameCarousel.currentIndex > 0) {
                                    gameCarousel.decrementCurrentIndex()
                                    gameCarousel.currentItem.forceActiveFocus()
                                }
                            }
                            Keys.onRightPressed: {
                                if (gameCarousel.currentIndex < gameCarousel.count - 1) {
                                    gameCarousel.incrementCurrentIndex()
                                    gameCarousel.currentItem.forceActiveFocus()
                                }
                            }
                            Keys.onReturnPressed: {
                                console.log("Selected game (enter):", gamesModel.get(index).name)
                            }
                            Keys.onUpPressed: {
                                tabRepeater.itemAt(0).forceActiveFocus()
                            }
                            Keys.onDownPressed: {
                                storeButton.forceActiveFocus()
                            }
                        }
                    }

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            gameCard.forceActiveFocus()
                        }
                    }
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.fillHeight: true
            color: "transparent"
            Layout.topMargin: 300 * mainWindow.scaleFactor
            visible: isDataLoaded

            ColumnLayout {
                width: 1800 * mainWindow.scaleFactor
                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        text: gamesModel && gamesModel.count > 0 ? gamesModel.get(gameCarousel.currentIndex).name : ""
                        color: "white"
                        font.pixelSize: 50 * mainWindow.scaleFactor
                        font.weight: Font.Bold
                    }
                    Item { Layout.fillWidth: true }
                    Text {
                        text: gamesModel && gamesModel.count > 0 ? "$" + gamesModel.get(gameCarousel.currentIndex).price : ""
                        color: "#4f9eee"
                        font.pixelSize: 45 * mainWindow.scaleFactor
                        font.weight: Font.Bold
                    }
                }

                Text {
                    Layout.fillWidth: true
                    text: gamesModel && gamesModel.count > 0 ? gamesModel.get(gameCarousel.currentIndex).description : ""
                    color: "white"
                    font.pixelSize: 35 * mainWindow.scaleFactor
                    wrapMode: Text.WordWrap
                }

                GridLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: 20
                    columns: 2
                    columnSpacing: 10 * mainWindow.scaleFactor
                    Text { text: "Genre:"; color: "white"; font.pixelSize: 25 * mainWindow.scaleFactor }
                    Text { text: gamesModel && gamesModel.count > 0 ? gamesModel.get(gameCarousel.currentIndex).genre : ""; color: "white"; font.pixelSize: 25 * mainWindow.scaleFactor }
                    Text { text: "Size:"; color: "white"; font.pixelSize: 25 * mainWindow.scaleFactor }
                    Text { text: gamesModel && gamesModel.count > 0 ? gamesModel.get(gameCarousel.currentIndex).size : ""; color: "white"; font.pixelSize: 25 * mainWindow.scaleFactor }
                    Text { text: "Rating:"; color: "white"; font.pixelSize: 25 * mainWindow.scaleFactor }
                    Text { text: gamesModel && gamesModel.count > 0 ? gamesModel.get(gameCarousel.currentIndex).rating + "/5" : ""; color: "white"; font.pixelSize: 25 * mainWindow.scaleFactor }
                    Text { text: "Multiplayer:"; color: "white"; font.pixelSize: 25 * mainWindow.scaleFactor }
                    Text { text: gamesModel && gamesModel.count > 0 ? (gamesModel.get(gameCarousel.currentIndex).multiplayer ? "Yes" : "No") : ""; color: "white"; font.pixelSize: 25 * mainWindow.scaleFactor }
                }
            }
        }

        Button {
            id: storeButton
            Layout.alignment: Qt.AlignLeft
            text: "Play Game"
            enabled: gamesModel && gamesModel.count > 0
            focus: false
            Material.accent: "#4f9eee"
            Material.foreground: "white"
            implicitWidth: 250 * mainWindow.scaleFactor
            implicitHeight: 100 * mainWindow.scaleFactor

            background: Rectangle {
                color: storeButton.activeFocus ? "#3a4f6d" : "#2a2f3d"
                radius: 5 * mainWindow.scaleFactor
                border.color: storeButton.activeFocus ? "#4f9eee" : "#3a3f4d"
                border.width: 2 * mainWindow.scaleFactor
                Behavior on color { ColorAnimation { duration: 200 } }
            }

            contentItem: Text {
                text: storeButton.text
                color: storeButton.activeFocus ? "#ffffff" : "#4f9eee"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: 25 * mainWindow.scaleFactor
                font.weight: Font.Bold
            }

            Keys.onReturnPressed: {
                if (gamesModel && gamesModel.count > 0) {
                    Qt.openUrlExternally(gamesModel.get(gameCarousel.currentIndex).storeLink)
                }
            }

            Keys.onUpPressed: {
                gameCarousel.forceActiveFocus()
            }

            onClicked: {
                if (gamesModel && gamesModel.count > 0) {
                    Qt.openUrlExternally(gamesModel.get(gameCarousel.currentIndex).storeLink)
                }
            }
        }
    }
}