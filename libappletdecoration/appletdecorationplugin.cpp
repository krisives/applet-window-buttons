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

#include "appletdecorationplugin.h"

#include "auroraetheme.h"
#include "decorationsmodel.h"
#include "padding.h"
#include "previewbridge.h"
#include "previewclient.h"
#include "previewbutton.h"
#include "previewsettings.h"
#include "schemesmodel.h"

#include "types.h"

#include <QtQml>
#include <QQmlEngine>

#include <KDecoration2/Decoration>

namespace Decoration {
namespace Applet {

void AppletDecorationPlugin::registerTypes(const char *uri)
{
    Q_ASSERT(uri == QLatin1String("org.kde.appletsdecoration"));

    qmlRegisterUncreatableType<Decoration::Applet::Types>(uri, 0, 1, "Types", "Applet decoration types");

    qmlRegisterType<Decoration::Applet::AuroraeTheme>(uri, 0, 1, "AuroraeTheme");
    qmlRegisterType<Decoration::Applet::BridgeItem>(uri, 0, 1, "Bridge");
    qmlRegisterType<Decoration::Applet::Settings>(uri, 0, 1, "Settings");
    qmlRegisterType<Decoration::Applet::PreviewButtonItem>(uri, 0, 1, "Button");
    qmlRegisterType<Decoration::Applet::DecorationsModel>(uri, 0, 1, "DecorationsModel");
    qmlRegisterType<Decoration::Applet::SchemesModel>(uri, 0, 1, "ColorsModel");

    qmlRegisterType<Decoration::Applet::Padding>();
    qmlRegisterType<Decoration::Applet::PreviewClient>();
    qmlRegisterType<Decoration::Applet::PreviewBridge>();
    qmlRegisterType<KDecoration2::Decoration>();
}

}
}


