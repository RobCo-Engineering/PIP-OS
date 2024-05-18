cmake_minimum_required(VERSION 3.16)

project(PipOS VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Core Quick)

qt_standard_project_setup()

qt_add_executable(appPipOS main.cpp)

set_source_files_properties(settings/DwellerSettings.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)
set_source_files_properties(settings/InterfaceSettings.qml PROPERTIES QT_QML_SINGLETON_TYPE TRUE)

qt_add_qml_module(appPipOS
    URI PipOS
    VERSION 1.0
    RESOURCE_PREFIX /RobCo
    QML_FILES
        Main.qml
        MainLayout.qml
        MainNavigation.qml
        MainFooter.qml
        BootSequence.qml
        SubMenu.qml
        PageData.qml
        PageItem.qml
        PageMap.qml
        PageRadio.qml
        PageStat.qml
        TabInventory.qml
        TabStatus.qml
        components/ItemStat.qml
        components/ProgressBar.qml
        settings/DwellerSettings.qml
        settings/InterfaceSettings.qml
    SOURCES
        bootscreen.h bootscreen.cpp
        dweller.h dweller.cpp
        inputeventhandler.h inputeventhandler.cpp
)

qt_add_resources(appPipOS "fonts"
    PREFIX "/"
    FILES
        fonts/Share-TechMono.ttf
        fonts/RobotoCondensedFallout.ttf
        fonts/RobotoCondensedLightFallout.ttf
        fonts/RobotoCondensedBoldFallout.ttf
)

qt_add_resources(appPipOS "images"
    PREFIX "/"
    FILES
        images/body_0.png
        images/boot_vaultboy.png
        images/head_0.png
        images/head_1.png
        images/armor.svg
        images/defence.svg
        images/initiating.svg
        images/weapon.svg

        images/ripped_ref.png
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appPipOS PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appPipOS
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appPipOS PRIVATE Qt6::Quick)

include(GNUInstallDirs)
install(TARGETS appPipOS
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
