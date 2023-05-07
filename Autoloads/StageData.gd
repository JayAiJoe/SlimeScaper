extends Node

enum TERRAIN {DIRT, GRASS, ROCK, WATER}
enum SLIME {GRASS, WATER, ROCK, FIRE}

const level_1 = {
	"map" : [
			[Vector2(0,0), TERRAIN.DIRT],[Vector2(0,0), TERRAIN.DIRT],[Vector2(0,0), TERRAIN.DIRT],
			[Vector2(1,0), TERRAIN.DIRT],[Vector2(1,0), TERRAIN.GRASS],
			[Vector2(2,0), TERRAIN.ROCK],
			[Vector2(3,0), TERRAIN.WATER],
		],
		
	"player_start" : Vector2(1,0),
	
	"slimes" : [
			[Vector2(0,0), SLIME.GRASS],
			[Vector2(3,0), SLIME.FIRE],
		]
}
