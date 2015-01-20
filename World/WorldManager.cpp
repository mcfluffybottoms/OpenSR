/*
    OpenSR - opensource multi-genre game based upon "Space Rangers 2: Dominators"
    Copyright (C) 2015 Kosyak <ObKo@mail.ru>

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

#include "WorldManager.h"

#include <QHash>

namespace OpenSR
{
namespace World
{
WorldManager* WorldManager::m_staticInstance = 0;
quint32 WorldManager::m_idPool = 0;

WorldManager::WorldManager(QObject *parent): QObject(parent)
{
    if (WorldManager::m_staticInstance)
        throw std::runtime_error("WorldManager constructed twice");

    WorldManager::m_staticInstance = this;
}

WorldManager::~WorldManager()
{
    WorldManager::m_staticInstance = 0;
}

WorldContext* WorldManager::context() const
{
    return m_context;
}

WorldManager* WorldManager::instance()
{
    return WorldManager::m_staticInstance;
}

quint32 WorldManager::getNextId() const
{
    return ++WorldManager::m_idPool;
}

bool WorldManager::loadWorld(const QString& path)
{

}

bool WorldManager::saveWorld(const QString& path)
{

}
}
}
