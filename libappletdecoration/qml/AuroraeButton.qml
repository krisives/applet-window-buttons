/*
*  Copyright 2018  Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of the libappletdecoration library
*
*  Latte-Dock is free software; you can redistribute it and/or
*  modify it under the terms of the GNU General Public License as
*  published by the Free Software Foundation; either version 2 of
*  the License, or (at your option) any later version.
*
*  Latte-Dock is distributed in the hope that it will be useful,
*  but WITHOUT ANY WARRANTY; without even the implied warranty of
*  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
*  GNU General Public License for more details.
*
*  You should have received a copy of the GNU General Public License
*  along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.7

import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.core 2.0 as PlasmaCore

import org.kde.appletdecoration 0.1 as AppletDecoration

MouseArea{
    id: button
    hoverEnabled: true

    property bool isActive: true
    property bool isOnAllDesktops: false
    property bool isMaximized: false
    readonly property bool isToggledActivated: {
        return (isOnAllDesktops && buttonType === AppletDecoration.Types.OnAllDesktops);
    }

    property int topPadding: 0
    property int bottomPadding: 0
    property int leftPadding: 0
    property int rightPadding: 0
    property int buttonType: AppletDecoration.Types.Close
    property int duration: auroraeTheme ? auroraeTheme.duration : 0

    property QtObject auroraeTheme: null

    property string buttonImagePath: auroraeTheme ? auroraeTheme.themePath + '/' + iconName + '.' + auroraeTheme.themeType : ""

    property string iconName: {
        switch(buttonType){
        case AppletDecoration.Types.Close: return "close";
        case AppletDecoration.Types.Minimize: return "minimize";
        case AppletDecoration.Types.Maximize: return "maximize";
        case AppletDecoration.Types.OnAllDesktops: return "alldesktops";
        default: return "close";
        }
    }

    property string svgNormalElementId:{
        return "active-center";
    }

    property string svgHoveredElementId:{
        return containsPress || isToggledActivated ? "pressed-center" : "hover-center";
    }

    PlasmaCore.Svg {
        id: buttonSvg
        imagePath: buttonImagePath
    }

    // normal icon
    Item {
        id: svgNormalItem
        anchors.fill: parent
        anchors.topMargin: topPadding
        anchors.bottomMargin: bottomPadding
        anchors.leftMargin: leftPadding
        anchors.rightMargin: rightPadding

        opacity: !containsMouse && !containsPress && !isToggledActivated ? 1 : 0

        PlasmaCore.SvgItem {
            anchors.centerIn: parent
            width: auroraeTheme.buttonRatio * height
            height: minimumSide

            property int minimumSide: Math.min(parent.width,parent.height)

            svg: buttonSvg
            elementId: svgNormalElementId
        }


        Behavior on opacity {
            NumberAnimation {
                duration: button.duration
                easing.type: Easing.Linear
            }
        }
    }

    // hovered icon
    PlasmaCore.SvgItem {
        id: svgHoveredItem
        anchors.fill: parent
        anchors.topMargin: topPadding
        anchors.bottomMargin: bottomPadding
        anchors.leftMargin: leftPadding
        anchors.rightMargin: rightPadding

        opacity: Math.abs(svgNormalItem.opacity - 1)

        PlasmaCore.SvgItem {
            anchors.centerIn: parent
            width: auroraeTheme.buttonRatio * height
            height: minimumSide

            property int minimumSide: Math.min(parent.width,parent.height)
            svg: buttonSvg
            elementId: svgHoveredElementId
        }
    }
}
