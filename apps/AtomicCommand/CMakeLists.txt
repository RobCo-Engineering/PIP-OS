cmake_minimum_required(VERSION 3.16)
project(AtomicCommand VERSION 1.0 LANGUAGES CXX)

find_package(Qt6 REQUIRED COMPONENTS Core)

qt_add_qml_module(appAtomicCommand
    URI AtomicCommand
    VERSION 1.0
    SOURCES
        atomiccommand.h atomiccommand.cpp
    QML_FILES
        Main.qml
)
