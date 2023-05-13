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
}

const MID_DIRS = {
	Vector2(2,-1) : {Vector2(1,0):[Vector2(2,0),Vector2(1,1),Vector2(0,1)],
					Vector2(1,-1):[Vector2(2,-2),Vector2(1,-2),Vector2(0,-1)]},
	Vector2(1,-2) : {Vector2(0,-1):[Vector2(0,-2),Vector2(-1,-1),Vector2(-1,0)],
					Vector2(1,-1):[Vector2(2,-2),Vector2(2,-1),Vector2(1,0)]},
	Vector2(-1,1) : {Vector2(-1,0):[Vector2(-1,1),Vector2(-2,1),Vector2(-2,0)],
					Vector2(0,-1):[Vector2(1,-1),Vector2(1,-2),Vector2(0,-2)]},
	Vector2(-2,1) : {Vector2(-1,0):[Vector2(-2,0),Vector2(-1,-1),Vector2(0,-1)],
					Vector2(-1,1):[Vector2(0,1),Vector2(-1,2),Vector2(-2,2)]},
	Vector2(-1,2) : {Vector2(-1,0):[Vector2(-2,0),Vector2(-1,-1),Vector2(0,-1)],
					Vector2(-1,1):[Vector2(0,1),Vector2(-1,2),Vector2(-2,2)]},
}

const DIR_TO_ANGLE = {
	Vector2(1,-1) : 0,
	Vector2(1,-2) : 30,
	Vector2(0,-1) : 60,
	Vector2(-1,-1) : 90,
	Vector2(-1,0) : 120,
	Vector2(-2,1) : 150,
	Vector2(-1,1) : 180,
	Vector2(-1,2) : 210,
	Vector2(0,1) : 240,
	Vector2(1,1) : 270,
	Vector2(1,0) : 300,
	Vector2(2,-1) : 330,
}

const ANGLE_TO_DIR = {
	0 : Vector2(1,-1),
	30 : Vector2(1,-2),
	60 : Vector2(0,-1),
	90 : Vector2(-1,-1),
	120 : Vector2(-1,0),
	150 : Vector2(-2,1),
	180 : Vector2(-1,1),
	210 : Vector2(-1,2),
	240 : Vector2(0,1),
	270 : Vector2(1,1),
	300 : Vector2(1,0),
	330 : Vector2(2,-1),
}

const KEY_BINDS = {"blue":{   
	"SE": "D",
	"NE": "E",
	"N" : "W",
	"NW": "Q",
	"SW": "A",
	"S" : "S",
	},
	"red":{   
	"SE": "L",
	"NE": "O",
	"N" : "I",
	"NW": "U",
	"SW": "J",
	"S" : "K",
	}}

const COLORS = {"blue":Color(0,0,1,1), "red":Color(1,0,0,1)}

const PLAYER_TRAIL_STRENGTH = 60

enum TERRAIN {DIRT, GRASS, ROCK, WATER, PLANT}

enum SLIME {GRASS, WATER, ROCK, FIRE}

var REACTIONS : Dictionary = {
	TERRAIN.DIRT : {SLIME.GRASS : TERRAIN.GRASS},
	TERRAIN.GRASS : {SLIME.FIRE : TERRAIN.DIRT, SLIME.WATER : TERRAIN.PLANT},
	TERRAIN.PLANT : {SLIME.FIRE : TERRAIN.DIRT, SLIME.ROCK : TERRAIN.GRASS},
}

const INGREDIENT_VARIETIES = 3
const CHOMPY_INDEX = 3

var INGREDIENT_NAMES = {
	0 : "onion",
	1 : "carrot",
	2 : "lettuce",
	3 : "CrowIdle",
}
