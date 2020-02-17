/*
 * =====================================================================================
 *
 *  OpenMiner
 *  Copyright (C) 2018-2020 Unarelith, Quentin Bazin <openminer@unarelith.net>
 *
 *  This program is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with this program; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA
 *
 * =====================================================================================
 */
#ifndef BLOCK_HPP_
#define BLOCK_HPP_

#include <glm/glm.hpp>

#include <sol.hpp>

#include <gk/core/Box.hpp>
#include <gk/core/IntTypes.hpp>

#include "ItemStack.hpp"
#include "ISerializable.hpp"
#include "TilesDef.hpp"

class Chunk;
class Player;
class World;

enum class BlockDrawType {
	Solid   = 0,
	XShape  = 1,
	Leaves  = 2,
	Liquid  = 3,
	Glass   = 4,
};

class Block : public ISerializable {
	public:
		Block() = default;
		Block(u32 id, const TilesDef &tiles, const std::string &name, const std::string &label);
		virtual ~Block() = default;

		void serialize(sf::Packet &packet) const override;
		void deserialize(sf::Packet &packet) override;

		u16 id() const { return m_id & 0xffff; }
		u16 data() const { return (m_id >> 16) & 0xffff; }
		const TilesDef &tiles() const { return m_tiles; }

		const std::string &name() const { return m_name; }
		const std::string &label() const { return m_label; }
		void setLabel(const std::string &label) { m_label = label; }

		std::string modName() const { return m_name.substr(0, m_name.find_first_of(":")); }

		bool isOpaque() const { return m_id != 0 && m_isOpaque && m_drawType != BlockDrawType::XShape; }
		void setOpaque(bool isOpaque) { m_isOpaque = isOpaque; }

		ItemStack getItemDrop() const { return ItemStack{m_itemDrop, m_itemDropAmount}; };
		void setItemDrop(const std::string &itemDrop, u16 itemDropAmount = 1) { m_itemDrop = itemDrop; m_itemDropAmount = itemDropAmount; }

		u8 harvestRequirements() const { return m_harvestRequirements; }
		void setHarvestRequirements(u8 harvestRequirements) { m_harvestRequirements = harvestRequirements; }

		float hardness() const { return m_hardness; }
		void setHardness(float hardness) { m_hardness = hardness; }

		float timeToBreak(u8 harvestCapability, float miningSpeed) const {
			return ((m_harvestRequirements & harvestCapability) == m_harvestRequirements) ? 1.5 * m_hardness / miningSpeed : 5 * m_hardness;
		}

		const gk::FloatBox &boundingBox() const { return m_boundingBox; }
		void setBoundingBox(const gk::FloatBox &boundingBox) { m_boundingBox = boundingBox; }

		BlockDrawType drawType() const { return m_drawType; }
		void setDrawType(BlockDrawType drawType) { m_drawType = drawType; }

		bool canUpdate() const { return m_canUpdate; }
		bool canBeActivated() const { return m_canBeActivated; }

		bool isLightSource() const { return m_isLightSource; }
		void setLightSource(bool isLightSource) { m_isLightSource = isLightSource; }

	protected:
		glm::vec4 getTexCoordsFromID(int textureID) const;

		bool m_canUpdate = false;
		bool m_canBeActivated = false;

	private:
		u32 m_id = 0;
		TilesDef m_tiles;

		std::string m_name;
		std::string m_label;

		std::string m_itemDrop;
		u16 m_itemDropAmount;

		u8 m_harvestRequirements = 0;
		float m_hardness = 1.0f;

		gk::FloatBox m_boundingBox{0, 0, 0, 1, 1, 1};

		BlockDrawType m_drawType = BlockDrawType::Solid;

		bool m_isOpaque = true;

		bool m_isLightSource = false;
};

#endif // BLOCK_HPP_
