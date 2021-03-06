/*
 * Copyright 2018  Michail Vourlakos <mvourlakos@gmail.com>
 *
 * This file is part of the libappletdecoration library
 *
 * Latte-Dock is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License as
 * published by the Free Software Foundation; either version 2 of
 * the License, or (at your option) any later version.
 *
 * Latte-Dock is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 */

#include "schemesmodel.h"

#include "schemecolors.h"

#include <QDebug>
#include <QDir>

namespace Decoration {
namespace Applet {

SchemesModel::SchemesModel(QObject *parent)
    : QAbstractListModel(parent)
{
    initSchemes();
}

SchemesModel::~SchemesModel()
{
    qDeleteAll(m_schemes);
}

QVariant SchemesModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.column() != 0 || index.row() < 0 || index.row() >= m_schemes.count()) {
        return QVariant();
    }

    const SchemeColors *d = m_schemes[index.row()];

    switch (role) {
        case Qt::DisplayRole:
            return index.row() == 0 ? "Current" : d->schemeName();

        case Qt::UserRole + 4:
            return index.row() == 0 ? "kdeglobals" : d->schemeFile();

        case Qt::UserRole + 5:
            return d->backgroundColor();

        case Qt::UserRole + 6:
            return d->textColor();
    }

    return QVariant();
}

int SchemesModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid()) {
        return 0;
    }

    return m_schemes.count();
}

QHash< int, QByteArray > SchemesModel::roleNames() const
{
    QHash<int, QByteArray> roles({
        {Qt::DisplayRole, QByteArrayLiteral("display")},
        {Qt::UserRole + 4, QByteArrayLiteral("file")},
        {Qt::UserRole + 5, QByteArrayLiteral("backgroundColor")},
        {Qt::UserRole + 6, QByteArrayLiteral("textColor")}
    });
    return roles;
}

void SchemesModel::initSchemes()
{
    qDeleteAll(m_schemes);
    m_schemes.clear();

    QString currentSchemePath = SchemeColors::possibleSchemeFile("kdeglobals");
    insertSchemeInList(currentSchemePath);

    QString userPath = QDir::homePath() + "/.local/share/color-schemes";
    QDir directory(userPath);
    QStringList localSchemes = directory.entryList(QStringList() << "*.colors" << "*.COLORS", QDir::Files);

    foreach (QString filename, localSchemes) {
        QString fullPath = userPath + "/" + filename;
        insertSchemeInList(fullPath);
    }

    QString globalPath = "/usr/share/color-schemes";
    directory.setPath(globalPath);
    QStringList globalSchemes = directory.entryList(QStringList() << "*.colors" << "*.COLORS", QDir::Files);

    foreach (QString filename, globalSchemes) {
        if (!localSchemes.contains(filename)) {
            QString fullPath = globalPath + "/" + filename;
            insertSchemeInList(fullPath);
        }
    }
}

void SchemesModel::insertSchemeInList(QString file)
{
    SchemeColors *tempScheme = new SchemeColors(this, file);

    int atPos{0};

    for (int i = 0; i < m_schemes.count(); i++) {
        SchemeColors *s = m_schemes[i];

        int result = QString::compare(tempScheme->schemeName(), s->schemeName(), Qt::CaseInsensitive);

        if (result < 0) {
            atPos = i;
            break;
        } else {
            atPos = i + 1;
        }

    }

    m_schemes.insert(atPos, tempScheme);
}

int SchemesModel::indexOf(QString file)
{
    if (file.isEmpty() || file == "kdeglobals") {
        return 0;
    }

    for (int i = 0; i < m_schemes.count(); i++) {
        SchemeColors *s = m_schemes[i];

        if (s->schemeFile() == file) {
            return i;
        }
    }

    return -1;
}

}
}
