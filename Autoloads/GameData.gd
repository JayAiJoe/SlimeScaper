extends Node


const DIRECTIONS = {   
	"move_SE": Vector2(1,0),
	"move_NE": Vector2(1,-1),
	"move_N" : Vector2(0,-1),
	"move_NW": Vector2(-1,0),
	"move_SW": Vector2(-1,1),
	"move_S" : Vector2(0,1),
}

enum TERRAIN_TYPES {DIRT, GRASS, ROCK, WATER}


enum SLIME_TYPES {GRASS, WATER, ROCK, FIRE}

var TERRAIN_REACTIONS : Dictionary = {
	TERRAIN_TYPES.DIRT : {SLIME_TYPES.GRASS : TERRAIN_TYPES.GRASS}
}
