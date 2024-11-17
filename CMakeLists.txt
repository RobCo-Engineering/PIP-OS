cmake_minimum_required(VERSION 3.22)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

project(PipOS LANGUAGES CXX)

# Set the output directory for build artifacts
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin)
set(PIPOS_QML_MODULES_PATH "${CMAKE_BINARY_DIR}/qml/PipOSApp")

set(SOURCES
    src/app.cpp
    src/hid.cpp
    src/dataprovider.cpp
    src/bootscreen.cpp
    src/dweller.cpp
    src/settings.cpp
    src/radio.cpp
)

set(HEADER
    inc/public/PipOS/app.h
    inc/public/PipOS/hid.h
    inc/public/PipOS/dataprovider.h
    inc/public/PipOS/bootscreen.h
    inc/public/PipOS/settings.h
    inc/public/PipOS/dweller.h
    inc/public/PipOS/radio.h
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
)

# Set QML import path for Qt Creator
list(APPEND QML_DIRS "${CMAKE_BINARY_DIR}/qml")  # Changed to point to the parent qml directory
set(QML_IMPORT_PATH
    "${QML_DIRS}"
    CACHE STRING "Qt Creator extra qml import paths")

find_package(Qt6 REQUIRED COMPONENTS Core Quick Multimedia Graphs Location)

add_library(PipOSApp STATIC)

target_include_directories(
    PipOSApp
    PUBLIC inc/public/
    PRIVATE src/)

# Note making this public is so that *_qmltyperegistrations.cpp can find the needed include
target_include_directories(PipOSApp PUBLIC src/ inc/public/PipOS)

qt_add_qml_module(PipOSApp
    URI PipOSApp
    OUTPUT_DIRECTORY ${PIPOS_QML_MODULES_PATH}
    RESOURCE_PREFIX /qml
    VERSION 1.0
    QML_FILES ${QML}
    SOURCES ${SOURCES} ${HEADER})

target_link_libraries(
    PipOSApp
    PUBLIC
    Qt6::Quick
    Qt6::Gui
    Qt6::Core
    Qt6::Multimedia
    Qt6::Graphs
    Qt6::Location
)

qt_add_executable(PipOS  main.cpp)
target_link_libraries(${PROJECT_NAME} PRIVATE PipOSApp PipOSAppplugin Qt6::Gui)

# qt_standard_project_setup()


qt_add_resources(PipOSApp "fonts"
    PREFIX "/"
    FILES
        assets/fonts/Share-TechMono.ttf
        assets/fonts/RobotoCondensedFallout.ttf
        assets/fonts/RobotoCondensedLightFallout.ttf
        assets/fonts/RobotoCondensedBoldFallout.ttf
)

qt_add_resources(PipOSApp "images"
    PREFIX "/"
    FILES
        assets/images/armor.svg
        assets/images/defence.svg
        assets/images/weapon.svg
        assets/images/hydration.svg
        assets/images/status_ok.gif
        assets/images/initiating.gif
        assets/images/radio_axis.svg
        assets/images/map_marker.svg
        assets/images/Strength.gif
        assets/images/Perception.gif
        assets/images/Endurance.gif
        assets/images/Charisma.gif
        assets/images/Intelligence.gif
        assets/images/Agility.gif
        assets/images/Luck.gif
)

qt_add_resources(PipOSApp "sounds"
    PREFIX "/"
    FILES
        assets/sounds/item_focus.wav
        assets/sounds/radio_on.wav
        assets/sounds/radio_off.wav
        assets/sounds/horizontal_tab.wav
)

# fonts
# include(CopyRecursive)
# set(FONTS_OUT_DIR "${RESOURCES_DIR}/fonts")
# file(MAKE_DIRECTORY ${FONTS_OUT_DIR})
# copy_recursive(${CMAKE_CURRENT_SOURCE_DIR}/assets/fonts ${FONTS_OUT_DIR} "*.ttf")
# copy_recursive(${CMAKE_CURRENT_SOURCE_DIR}/assets/fonts ${FONTS_OUT_DIR} "*.otf")

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
# set_target_properties(${PROJECT_NAME} PROPERTIES
# #    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appPipOS
#     MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
#     MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
#     MACOSX_BUNDLE TRUE
#     WIN32_EXECUTABLE TRUE
# )



# include(GNUInstallDirs)
install(TARGETS ${PROJECT_NAME}
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
