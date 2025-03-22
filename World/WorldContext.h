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

#ifndef OPENSR_WORLD_WORLDCONTEXT_H
#define OPENSR_WORLD_WORLDCONTEXT_H

#include "WorldObject.h"

#include "PlanetarySystem.h"
#include "ResourceManager.h"

namespace OpenSR
{
namespace World
{
class OPENSR_WORLD_API WorldContext: public WorldObject
{
    Q_OBJECT
    OPENSR_WORLD_OBJECT

    Q_PROPERTY(PlanetarySystem* currentSystem READ currentSystem WRITE setCurrentSystem NOTIFY currentSystemChanged STORED false)
    Q_PROPERTY(ResourceManager* resources  READ resources  NOTIFY resourcesChanged  STORED false)
    Q_PROPERTY(WorldObject*     playerShip READ playerShip NOTIFY playerShipChanged STORED false
                                           WRITE setPlayerShip)

public:
    Q_INVOKABLE WorldContext(WorldObject *parent = 0, quint32 id = 0);
    virtual ~WorldContext();

    PlanetarySystem* currentSystem() const;
    ResourceManager* resources() const;

    Q_INVOKABLE QObject* findObject(const QString& name) const;

    void setCurrentSystem(PlanetarySystem *system);

    virtual quint32 typeId() const;
    virtual QString namePrefix() const;

    virtual bool save(QDataStream &stream) const;
    virtual bool load(QDataStream &stream, const QMap<quint32, WorldObject*>& objects);

    WorldObject *playerShip() const;
    void setPlayerShip(WorldObject *);

Q_SIGNALS:
    void currentSystemChanged();
    void resourcesChanged();

    void playerShipChanged(WorldObject* playerShip);

private:
    PlanetarySystem *m_currentSystem;
    ResourceManager *m_resources;
    WorldObject* m_playerShip;
};
}
}

#endif // OPENSR_WORLD_WORLDCONTEXT_H
