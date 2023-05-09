extends Node

enum TERRAIN {DIRT, GRASS, ROCK, WATER}
enum SLIME {GRASS, WATER, ROCK, FIRE}

const LEVEL_DATA = {
	"level_1" : {
		"map" : [
			[Vector2(0,0), TERRAIN.DIRT],[Vector2(0,0), TERRAIN.DIRT],[Vector2(0,0), TERRAIN.DIRT],
			[Vector2(1,0), TERRAIN.DIRT],[Vector2(1,0), TERRAIN.GRASS],
			[Vector2(2,0), TERRAIN.ROCK],
			[Vector2(3,0), TERRAIN.WATER],
		],
			
		"blue_start" : Vector2(1,0),
		"red_start" : Vector2(1,0),
		
		"slimes" : [
			[Vector2(0,0), SLIME.GRASS],
			[Vector2(3,0), SLIME.WATER],
		]
	},
	
	"level_2" : {
		"map" : [
			[Vector2(0,0), TERRAIN.DIRT],[Vector2(0,1), TERRAIN.DIRT],[Vector2(0,2), TERRAIN.DIRT],[Vector2(0,3), TERRAIN.DIRT],
			[Vector2(1,0), TERRAIN.DIRT],[Vector2(1,1), TERRAIN.DIRT],[Vector2(1,2), TERRAIN.DIRT],[Vector2(1,3), TERRAIN.DIRT],
			[Vector2(2,0), TERRAIN.DIRT],[Vector2(2,1), TERRAIN.DIRT],[Vector2(2,2), TERRAIN.DIRT],[Vector2(2,3), TERRAIN.DIRT],
			[Vector2(3,0), TERRAIN.DIRT],[Vector2(3,1), TERRAIN.DIRT],[Vector2(3,2), TERRAIN.DIRT],[Vector2(3,3), TERRAIN.DIRT],
		],
			
		"blue_start" : Vector2(0,2),
		"red_start" : Vector2(3,3),
		
		"slimes" : [
			[Vector2(0,3), SLIME.GRASS],
		]
	},
	
	"level_3" : {
		"map" : [
			[Vector2(0,0), TERRAIN.DIRT],[Vector2(0,1), TERRAIN.DIRT],[Vector2(0,2), TERRAIN.DIRT],[Vector2(0,3), TERRAIN.DIRT],
			[Vector2(-1,0), TERRAIN.DIRT],[Vector2(-1,1), TERRAIN.DIRT],[Vector2(-1,2), TERRAIN.DIRT],[Vector2(-1,3), TERRAIN.DIRT],
			[Vector2(-2,0), TERRAIN.DIRT],[Vector2(-2,1), TERRAIN.DIRT],[Vector2(-2,2), TERRAIN.DIRT],
			[Vector2(-3,1), TERRAIN.DIRT],[Vector2(-3,2), TERRAIN.DIRT],
		],
			
		"player_start" : Vector2(0,1),
		
		"slimes" : [
			[Vector2(0,0), SLIME.GRASS],
		]
	},
	
	"level_4" : {
		"map" : [
			[Vector2(0,0), TERRAIN.DIRT],[Vector2(0,1), TERRAIN.DIRT],[Vector2(0,2), TERRAIN.DIRT],
			[Vector2(0,3), TERRAIN.DIRT],
			[Vector2(0,4), TERRAIN.DIRT],
			[Vector2(0,5), TERRAIN.DIRT],
			[Vector2(0,6), TERRAIN.DIRT],
			[Vector2(0,7), TERRAIN.DIRT],
		],
			
		"player_start" : Vector2(0,1),
		
		"slimes" : [
			[Vector2(0,0), SLIME.GRASS],
		]
	},
}
