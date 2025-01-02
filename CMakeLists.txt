cmake_minimum_required(VERSION 3.22)

project(PipOS VERSION 1.0 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTORCC ON)
set(QT_QML_GENERATE_QMLLS_INI ON)

# Set the output directory for build artifacts
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
# set(PIPOS_QML_MODULES_PATH "${CMAKE_BINARY_DIR}/qml")

set(SOURCES
    src/app.cpp
    src/events.cpp
    src/dataprovider.cpp
    src/bootscreen.cpp
    src/dweller.cpp
    src/settings.cpp
    src/radio.cpp
    src/holotape.cpp
)

set(HEADER
    inc/public/PipOS/app.h
    inc/public/PipOS/events.h
    inc/public/PipOS/dataprovider.h
    inc/public/PipOS/bootscreen.h
    inc/public/PipOS/settings.h
    inc/public/PipOS/dweller.h
    inc/public/PipOS/radio.h
    inc/public/PipOS/holotape.h
)

set(QML
    main.qml
    qml/HealthBar.qml
    qml/BootSequence.qml
    qml/ItemStat.qml
    qml/Layout/MainLayout.qml
    qml/Layout/MainFooter.qml
    qml/Layout/MainNavigation.qml
    qml/Layout/MainNavigationTab.qml
    qml/Layout/SubMenu.qml
    qml/Layout/MainState.qml
    qml/Pages/PageStat.qml
    qml/Pages/PageItem.qml
    qml/Pages/PageData.qml
    qml/Pages/PageMap.qml
    qml/Pages/PageRadio.qml
    qml/Tabs/TabStatus.qml
    qml/Tabs/TabCollections.qml
    qml/Tabs/TabEffects.qml
    qml/Tabs/TabInventory.qml
    qml/Tabs/TabRadio.qml
    qml/Tabs/TabQuests.qml
    qml/Tabs/TabSpecial.qml
    qml/Tabs/FrequencyGraph.qml
    qml/JSONListModel/JSONListModel.qml
    qml/JSONListModel/json-query.js
    qml/Programs/AtomicCommand.qml
)

# Set QML import path for Qt Creator
list(APPEND QML_DIRS "${CMAKE_BINARY_DIR}/PipOS")  # Changed to point to the parent qml directory
set(QML_IMPORT_PATH
    "${QML_DIRS}"
    CACHE STRING "Qt Creator extra qml import paths")

find_package(Qt6 REQUIRED COMPONENTS Core Quick Multimedia Graphs Location)

qt_standard_project_setup(REQUIRES 6.5)
qt_add_executable(appPipOS main.cpp)

# add_library(appPipOS STATIC)

target_include_directories(appPipOS
    PUBLIC inc/public inc/public/PipOS
    PRIVATE src
)

# Note making this public is so that *_qmltyperegistrations.cpp can find the needed include
# target_include_directories(appPipOS PUBLIC src/ inc/public/PipOS)

qt_policy(SET QTP0004 NEW)

qt_add_qml_module(appPipOS
    URI PipOS
    VERSION 1.0
    # OUTPUT_DIRECTORY ${PIPOS_QML_MODULES_PATH}
    RESOURCE_PREFIX /robco-industries.org
    QML_FILES ${QML}
    SOURCES ${SOURCES} ${HEADER}
)

# qt_add_qml_module(appPipOS
#     URI JSONListModel
#     VERSION 1.0
#     QML_FILES
#         qml/JSONListModel/JSONListModel.qml
#         qml/JSONListModel/json-query.js
#     )

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appPipOS PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appEmptyQTProject
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(
    appPipOS
    PUBLIC
        Qt6::Quick
        Qt6::Gui
        Qt6::Core
        Qt6::Multimedia
        Qt6::Graphs
        Qt6::Location
)


qt_add_resources(appPipOS "fonts"
    BASE "assets"
    FILES
        assets/fonts/Share-TechMono.ttf
        assets/fonts/RobotoCondensedFallout.ttf
        assets/fonts/RobotoCondensedLightFallout.ttf
        assets/fonts/RobotoCondensedBoldFallout.ttf
)

qt_add_resources(appPipOS "images"
    BASE "assets"
    FILES
        assets/images/status/armor.svg
        assets/images/status/defence.svg
        assets/images/status/weapon.svg
        assets/images/status/damage.svg
        assets/images/status/cryo.svg
        assets/images/status/energy.svg
        assets/images/status/fire.svg
        assets/images/status/poison.svg
        assets/images/status/radiation.svg
        assets/images/hydration.svg
        assets/images/status_ok.gif
        assets/images/initiating.gif
        assets/images/radio_axis.svg
        assets/images/map_marker.svg
        assets/images/quest_default.gif
        assets/images/SPECIAL/Strength.gif
        assets/images/SPECIAL/Perception.gif
        assets/images/SPECIAL/Endurance.gif
        assets/images/SPECIAL/Charisma.gif
        assets/images/SPECIAL/Intelligence.gif
        assets/images/SPECIAL/Agility.gif
        assets/images/SPECIAL/Luck.gif
        assets/images/AtomicCommandStart.gif
)

qt_add_resources(appPipOS "sounds"
    BASE "assets"
    FILES
        assets/sounds/item_focus.wav
        assets/sounds/radio_on.wav
        assets/sounds/radio_off.wav
        assets/sounds/horizontal_tab.wav
)

include(GNUInstallDirs)
install(TARGETS appPipOS
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
