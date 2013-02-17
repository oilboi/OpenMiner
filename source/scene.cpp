#include <string>
#include <vector>
#include <map>

#include <SDL/SDL.h>
#include <GL/gl.h>
#include <GL/glu.h>

#include "sdlglutils.h"

#include "init.h"
#include "config.h"
#include "types.h"
#include "player.h"
#include "map.h"
#include "cube.h"
#include "biome.h"
#include "scene.h"

Player *Scene::player;

Scene::Scene() {
	//player = new Player(7, 7, 5, 90);
	player = new Player(4, 4, 2, 90);
	
	loadTextures();
	
	m_biome = new Biome(0, 0, 0, m_textures["stone"]);
}

Scene::~Scene() {
	// Deleting loaded textures
	for(Textures::iterator element = m_textures.begin() ; element != m_textures.end() ; element++) {
		glDeleteTextures(1, &element->second);
		element->second = 0;
	}
	
	delete m_biome;
	delete m_player;
}

void Scene::exec() {
	//lockMouse();
	
	m_cont = true;
	
	while(m_cont) {
		manageEvents();
		animate();
		draw();
		display();
	}
	
	//unlockMouse();
}

void Scene::manageEvents() {
	SDL_Event event;
	
	while(SDL_PollEvent(&event)) {
		switch(event.type) {
			case SDL_QUIT:
				m_cont = false;
				break;
				
			case SDL_MOUSEMOTION:
				if((WIN_WIDTH / 2) != event.motion.x || (WIN_HEIGHT / 2) != event.motion.y) {
					m_player->turnH(-event.motion.xrel * 0.06);
					m_player->turnV(-event.motion.yrel * 0.06);
					
					SDL_WarpMouse((WIN_WIDTH / 2), (WIN_HEIGHT / 2));
				}
				break;
				
			case SDL_KEYDOWN:
				if(event.key.keysym.sym == SDLK_ESCAPE) {
					m_cont = false;
				}
				break;
		}
	}
}

void Scene::animate() {
	// Read keys state
	u8 *keys = SDL_GetKeyState(NULL);
	
	float direction = 0.0;
	bool movement = false;
	
	// Forward
	if(keys[SDLK_z]) {
		movement = true;
		
		if(keys[SDLK_q]) direction = 45.0;
		else if(keys[SDLK_d]) direction = -45.0;
		
		else direction = 0.0;
	}
	
	// Back
	else if(keys[SDLK_s]) {
		movement = true;
		
		if(keys[SDLK_q]) direction = 135.0;
		else if(keys[SDLK_d]) direction = -135.0;
		
		else direction = 180.0;
	}
	
	if(movement == false) {
		// Left
		if(keys[SDLK_q]) {
			direction = 90.0;
			movement = true;
		}
		
		// Right
		else if(keys[SDLK_d]) {
			direction = -90.0;
			movement = true;
		}
	}
	
	if(keys[SDLK_SPACE]) {
		m_player->fly();
	}
	else if(keys[SDLK_LSHIFT]) {
		m_player->land();
	}
	
	if(movement) {
		#define MOVEMENT_SPEED (2.0f)
		
		float distance = 20 * MOVEMENT_SPEED / 1000.0f;
		
		m_player->move(distance, direction);
	}
}

void Scene::draw() {

	// Clean screen
	glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
	
	// Put camera
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	m_player->watch();
	
	// Drawing field
	drawField();
}

void Scene::display() {
	glFlush();
	
	SDL_GL_SwapBuffers();
}

void Scene::loadTextures() {
	// Load textures
	m_textures["ground"] = loadTexture("textures/ground.bmp");
	m_textures["dirt"] = loadTexture("textures/dirt.bmp");
	m_textures["grass"] = loadTexture("textures/grass.bmp");
	m_textures["cobble"] = loadTexture("textures/cobble.bmp");
	m_textures["stone"] = loadTexture("textures/stone.bmp");
}

void Scene::drawField() {
	// Turn on textures
	glEnable(GL_TEXTURE_2D);
	
	// Select texture
	glBindTexture(GL_TEXTURE_2D, m_textures["ground"]);
	
	// Add texture to scene
	glBegin(GL_QUADS);
	
	glColor3ub(255, 255, 255);
		glTexCoord2d(0, 1); glVertex3d(0, 0, -0.1);
		glTexCoord2d(0, 0); glVertex3d(50, 0, -0.1);
		glTexCoord2d(1, 0); glVertex3d(50, 50, -0.1);
		glTexCoord2d(1, 1); glVertex3d(0, 50, -0.1);
	
	glEnd();
	
	m_biome->draw();
	
	glPushMatrix();
	glLoadIdentity();
	
	glMatrixMode(GL_PROJECTION);
	glPushMatrix();
	glLoadIdentity();
	
	gluOrtho2D(-400.0, 400.0, -300.0, 300.0);
	
	glMatrixMode(GL_MODELVIEW);
	
	glBindTexture(GL_TEXTURE_2D, m_textures["dirt"]);
	
	glBegin(GL_LINES);
	
	glColor3f(1.0f, 1.0f, 1.0f);
		glVertex2i(-10, 0);
		glVertex2i(10, 0);
		glVertex2i(0, -10);
		glVertex2i(0, 10);
	
	glEnd();
	
	glMatrixMode(GL_PROJECTION);
	glPopMatrix();
	
	glMatrixMode(GL_MODELVIEW);
	glPopMatrix();	
}

void Scene::lockMouse() {
	SDL_WM_GrabInput(SDL_GRAB_ON);
	
	SDL_WarpMouse((WIN_WIDTH / 2), (WIN_HEIGHT / 2));
	
	SDL_ShowCursor(false);
}

void Scene::unlockMouse() {
	SDL_WM_GrabInput(SDL_GRAB_OFF);
	
	SDL_ShowCursor(true);
}

