extends Node


const DIRECTIONS = {   
	"move_SE": Vector2(1,0),
	"move_NE": Vector2(1,-1),
	"move_N" : Vector2(0,-1),
	"move_NW": Vector2(-1,0),
	"move_SW": Vector2(-1,1),
	"move_S" : Vector2(0,1),
}

const TERRAIN_TYPES = {
	0 : "dirt",
	1 : "grass",
	2 : "stone_hill",
}
