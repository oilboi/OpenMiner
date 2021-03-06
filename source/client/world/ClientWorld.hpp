/*
 * =====================================================================================
 *
 *  OpenMiner
 *
 *  Copyright (C) 2018-2020 Unarelith, Quentin Bazin <openminer@unarelith.net>
 *  Copyright (C) 2019-2020 the OpenMiner contributors (see CONTRIBUTORS.md)
 *
 *  This file is part of OpenMiner.
 *
 *  OpenMiner is free software; you can redistribute it and/or
 *  modify it under the terms of the GNU Lesser General Public
 *  License as published by the Free Software Foundation; either
 *  version 2.1 of the License, or (at your option) any later version.
 *
 *  OpenMiner is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 *  Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public License
 *  along with OpenMiner; if not, write to the Free Software Foundation, Inc.,
 *  51 Franklin Street, Fifth Floor, Boston, MA  02110-1301 USA
 *
 * =====================================================================================
 */
#ifndef CLIENTWORLD_HPP_
#define CLIENTWORLD_HPP_

#include <unordered_map>

#include <gk/gl/Camera.hpp>
#include <gk/core/Vector4.hpp>

#include "ClientChunk.hpp"
#include "ClientScene.hpp"
#include "Network.hpp"
#include "World.hpp"

class ClientCommandHandler;
class Sky;
class TextureAtlas;

class ClientWorld : public World, public gk::Drawable {
	using ChunkMap = std::unordered_map<gk::Vector3i, std::unique_ptr<ClientChunk>>;

	public:
		ClientWorld();

		void update();
		void sendChunkRequests();
		void checkPlayerChunk(double playerX, double playerY, double playerZ);

		void clear();

		void changeDimension(u16 dimensionID);

		void receiveChunkData(Network::Packet &packet);
		void removeChunk(ChunkMap::iterator &it);

		Chunk *getChunk(int cx, int cy, int cz) const override;

		const ClientScene &scene() const { return m_scene; }
		ClientScene &scene() { return m_scene; }

		void setClient(ClientCommandHandler &client) { m_client = &client; }
		void setCamera(gk::Camera &camera) { m_camera = &camera; m_scene.setCamera(camera); }

		std::size_t loadedChunkCount() const { return m_chunks.size(); }

	private:
		void createChunkNeighbours(ClientChunk *chunk);

		void draw(gk::RenderTarget &target, gk::RenderStates states) const override;

		const Dimension *m_dimension = nullptr;

		ClientScene m_scene;

		ChunkMap m_chunks;

		TextureAtlas &m_textureAtlas;

		ClientCommandHandler *m_client = nullptr;
		gk::Camera *m_camera = nullptr;

		mutable gk::Vector4d m_closestInitializedChunk{0, 0, 0, 1000000};

		const Sky *m_sky = nullptr;
};

#endif // CLIENTWORLD_HPP_
