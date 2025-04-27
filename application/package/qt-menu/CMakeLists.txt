cmake_minimum_required(VERSION 3.16)
project(qt-menu VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 REQUIRED COMPONENTS Core Gui Quick Qml)

qt_add_executable(qt-menu main.cpp resource.qrc)

qt_add_qml_module(qt-menu
    URI QTMenu
    VERSION 1.0
    QML_FILES
        qml/main.qml
)

target_link_libraries(qt-menu PRIVATE
    Qt6::Core
    Qt6::Gui
    Qt6::Quick
    Qt6::Qml
)

install(TARGETS qt-menu DESTINATION /usr/bin)