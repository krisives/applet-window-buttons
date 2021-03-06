/*
*  Copyright 2018  Michail Vourlakos <mvourlakos@gmail.com>
*
*  This file is part of Latte-Dock
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

import QtQuick 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls 2.4 as Controls24
import QtQuick.Layouts 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.appletdecoration 0.1 as AppletDecoration

Item {
    id: root

    property alias cfg_useCurrentDecoration: root.useCurrent
    property alias cfg_selectedPlugin: root.selectedPlugin
    property alias cfg_selectedScheme: root.selectedScheme
    property alias cfg_selectedTheme: root.selectedTheme
    property alias cfg_buttons: root.currentButtons
    property alias cfg_showOnlyForActiveAndMaximized: onlyOnMaximizedChk.checked
    property alias cfg_slideAnimation: slideChk.checked
    property alias cfg_useDecorationMetrics: decorationMetricsChk.checked
    property alias cfg_spacing: spacingSpn.value
    property alias cfg_thicknessMargin: thickSpn.value
    property alias cfg_lengthFirstMargin: lengthFirstSpn.value
    property alias cfg_lengthLastMargin: lengthLastSpn.value
    property alias cfg_lengthMarginsLock: lockItem.locked

    // used as bridge to communicate properly between configuration and ui
    property bool useCurrent
    property string selectedPlugin
    property string selectedScheme
    property string selectedTheme
    property string currentButtons

    // used from the ui
    readonly property real centerFactor: 0.35
    readonly property int minimumWidth: 220
    property string currentPlugin: root.useCurrent ? decorations.currentPlugin : root.selectedPlugin
    property string currentTheme: root.useCurrent ? decorations.currentTheme : root.selectedTheme

    ///START Decoration Items
    AppletDecoration.Bridge {
        id: bridgeItem
        plugin: currentPlugin
        theme: currentTheme
    }

    AppletDecoration.Settings {
        id: settingsItem
        bridge: bridgeItem.bridge
        borderSizesIndex: 0
    }

    AppletDecoration.AuroraeTheme {
        id: auroraeThemeEngine
        theme: isEnabled ? currentTheme : ""

        readonly property bool isEnabled: decorations.isAurorae(root.currentPlugin, root.currentTheme);
    }

    AppletDecoration.DecorationsModel {
        id: decorations
    }

    AppletDecoration.ColorsModel {
        id: colorsModel
    }

    SystemPalette {
        id: palette
    }

    // sort decorations based on display name
    PlasmaCore.SortFilterModel {
        id: sortedDecorations
        sourceModel: decorations
        sortRole: 'display'
        sortOrder: Qt.AscendingOrder
    }

    ///END Decoration Items

    ColumnLayout {
        id:mainColumn
        spacing: units.largeSpacing
        Layout.fillWidth: true

        RowLayout{
            Label {
                Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                text: i18n("Decoration:")
                horizontalAlignment: Text.AlignRight
            }

            DecorationsComboBox{
                id: decorationCmb
                Layout.minimumWidth: 180
                Layout.preferredWidth: 0.2 * root.width
                Layout.maximumWidth: 300
            }
        }

        RowLayout{
            visible: !auroraeThemeEngine.isEnabled

            Label {
                Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                text: i18n("Colors:")
                horizontalAlignment: Text.AlignRight
            }

            ColorsComboBox{
                Layout.minimumWidth: 250
                Layout.preferredWidth: 0.3 * root.width
                Layout.maximumWidth: 380

                model: colorsModel
                textRole: "display"

                Component.onCompleted: {
                    currentIndex = colorsModel.indexOf(plasmoid.configuration.selectedScheme);
                }
            }
        }

        GridLayout{
            columns: 2

            Label{
                Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                text: i18n("Buttons:")
                horizontalAlignment: Text.AlignRight
            }

            OrderableListView{
                id: activeButtons
                itemWidth: 36
                itemHeight: 36
                buttonsStr: root.currentButtons
                orientation: ListView.Horizontal
            }
        }

        GridLayout{
            id: behaviorGrid
            columns: 2

            Label{
                Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                text: i18n("Visual behavior:")
                horizontalAlignment: Text.AlignRight
            }

            CheckBox{
                id: onlyOnMaximizedChk
                text: i18n("Show only when active window is maximized")
            }

            Label{
            }

            CheckBox{
                id: slideChk
                text: i18n("Slide animation in order to show or hide")
            }
        }

        ColumnLayout{
            id: visualSettings

            GridLayout{
                id: visualSettingsGroup1
                columns: 2

                Label{
                    Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                    text: i18n("Metrics:")
                    horizontalAlignment: Text.AlignRight
                }

                CheckBox{
                    id: decorationMetricsChk
                    text: i18n("Use from decoration if any are found")
                }

                Label{
                    Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                    text: i18n("Icons spacing:")
                    horizontalAlignment: Text.AlignRight
                    enabled: !(auroraeThemeEngine.isEnabled && decorationMetricsChk.checked)
                }

                SpinBox{
                    id: spacingSpn
                    minimumValue: 0
                    maximumValue: 24
                    suffix: " " + i18nc("pixels","px.")
                    enabled: !(auroraeThemeEngine.isEnabled && decorationMetricsChk.checked)
                }

                Label{
                    Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                    text: i18n("Thickness margin:")
                    horizontalAlignment: Text.AlignRight
                    enabled: !(auroraeThemeEngine.isEnabled && decorationMetricsChk.checked)
                }

                SpinBox{
                    id: thickSpn
                    minimumValue: 0
                    maximumValue: 24
                    suffix: " " + i18nc("pixels","px.")
                    enabled: !(auroraeThemeEngine.isEnabled && decorationMetricsChk.checked)
                }
            }

            GridLayout{
                id: visualSettingsGroup2

                columns: 3
                rows: 2
                flow: GridLayout.TopToBottom
                columnSpacing: visualSettingsGroup1.columnSpacing
                rowSpacing: visualSettingsGroup1.rowSpacing

                property int lockerHeight: firstLengthLbl.height + rowSpacing/2

                Label{
                    id: firstLengthLbl
                    Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                    text: plasmoid.configuration.formFactor===PlasmaCore.Types.Horizontal ?
                              i18n("Left margin:") : i18n("Top margin:")
                    horizontalAlignment: Text.AlignRight
                }

                Label{
                    Layout.minimumWidth: Math.max(centerFactor * root.width, minimumWidth)
                    text: plasmoid.configuration.formFactor===PlasmaCore.Types.Horizontal ?
                              i18n("Right margin:") : i18n("Bottom margin:")
                    horizontalAlignment: Text.AlignRight

                    enabled: !lockItem.locked
                }

                SpinBox{
                    id: lengthFirstSpn
                    minimumValue: 0
                    maximumValue: 24
                    suffix: " " + i18nc("pixels","px.")

                    property int lastValue: -1

                    onValueChanged: {
                        if (lockItem.locked) {
                            var step = value - lastValue > 0 ? 1 : -1;
                            lastValue = value;
                            lengthLastSpn.value = lengthLastSpn.value + step;
                        }
                    }

                    Component.onCompleted: {
                        lastValue = plasmoid.configuration.lengthFirstMargin;
                    }
                }

                SpinBox{
                    id: lengthLastSpn
                    minimumValue: 0
                    maximumValue: 24
                    suffix: " " + i18nc("pixels","px.")
                    enabled: !lockItem.locked
                }

                LockItem{
                    id: lockItem
                    Layout.minimumWidth: 40
                    Layout.maximumWidth: 40
                    Layout.alignment: Qt.AlignTop | Qt.AlignLeft
                    Layout.minimumHeight: visualSettingsGroup2.lockerHeight
                    Layout.maximumHeight: Layout.minimumHeight
                    Layout.topMargin: firstLengthLbl.height / 2
                    Layout.rowSpan: 2
                }
            }
        }
    }
}
