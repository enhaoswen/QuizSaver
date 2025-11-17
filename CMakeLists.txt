cmake_minimum_required(VERSION 3.16)

project(QuizSaver VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appQuizSaver
    main.cpp
)

qt_add_qml_module(appQuizSaver
    URI QuizSaver
    VERSION 1.0
    QML_FILES
        Main.qml
        RESOURCES
        SOURCES
        SOURCES
        SOURCES
        SOURCES
        SOURCES mem.h
        SOURCES the_best_json.h the_best_json.cpp
        SOURCES
        SOURCES blureffect.h blureffect.cpp
        SOURCES
        SOURCES
        SOURCES
        SOURCES windowmanager.h windowmanager.cpp
        SOURCES
        SOURCES handle_info.h handle_info.cpp
        QML_FILES
        QML_FILES
        SOURCES
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appQuizSaver PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appQuizSaver
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appQuizSaver
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appQuizSaver
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
