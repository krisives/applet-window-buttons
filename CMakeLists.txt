project(applet_windowbuttons)
cmake_minimum_required(VERSION 3.0 FATAL_ERROR)

set(CMAKE_CXX_STANDARD 14)
set(VERSION 0.1.0)
set(AUTHOR "Michail Vourlakos")
set(EMAIL "mvourlakos@gmail.com")

set(QT_MIN_VERSION "5.9.0")
set(KF5_MIN_VERSION "5.38.0")

set(KF5_LOCALE_PREFIX "")

find_package(ECM ${KF5_MIN_VER} REQUIRED NO_MODULE)
set(CMAKE_MODULE_PATH ${ECM_MODULE_PATH} ${ECM_KDE_MODULE_DIR})

find_package(Qt5 ${QT_MIN_VERSION} CONFIG REQUIRED NO_MODULE COMPONENTS Gui Qml Quick)
find_package(KF5 ${KF5_MIN_VERSION} REQUIRED COMPONENTS CoreAddons Declarative Plasma PlasmaQuick)
find_package(KDecoration2 REQUIRED)

include(ECMQMLModules)
include(CheckIncludeFiles)
include(KDECMakeSettings)
include(KDEInstallDirs)

add_subdirectory(libappletdecoration)
plasma_install_package(package org.kde.windowbuttons)
