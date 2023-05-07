extends Node


const DIRECTIONS = {   
	"move_SE": Vector2(1,0),
	"move_NE": Vector2(1,-1),
	"move_N" : Vector2(0,-1),
	"move_NW": Vector2(-1,0),
	"move_SW": Vector2(-1,1),
	"move_S" : Vector2(0,1),
}

const DIRECTION_NAMES = {
	Vector2(1,0) : "move_SE",
	Vector2(1,-1) : "move_NE",
	Vector2(0,-1) : "move_N",
	Vector2(-1,0) : "move_NW",
	Vector2(-1,1) : "move_SW",
	Vector2(0,1) : "move_S",
	Vector2(0,0) : ""
}

const PLAYER_TRAIL_STRENGTH = 7

enum TERRAIN {DIRT, GRASS, ROCK, WATER, PLANT}

enum SLIME {GRASS, WATER, ROCK, FIRE}

var REACTIONS : Dictionary = {
	TERRAIN.DIRT : {SLIME.GRASS : TERRAIN.GRASS},
	TERRAIN.GRASS : {SLIME.FIRE : TERRAIN.DIRT, SLIME.WATER : TERRAIN.PLANT},
	TERRAIN.PLANT : {SLIME.FIRE : TERRAIN.DIRT, SLIME.ROCK : TERRAIN.GRASS},
	
}
