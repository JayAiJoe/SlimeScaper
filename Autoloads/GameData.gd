extends Node


const DIRECTIONS = {   
	"SE": Vector2(1,0),
	"NE": Vector2(1,-1),
	"N" : Vector2(0,-1),
	"NW": Vector2(-1,0),
	"SW": Vector2(-1,1),
	"S" : Vector2(0,1),
}

const DIRECTION_NAMES = {
	Vector2(1,0) : "SE",
	Vector2(1,-1) : "NE",
	Vector2(0,-1) : "N",
	Vector2(-1,0) : "NW",
	Vector2(-1,1) : "SW",
	Vector2(0,1) : "S",
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
