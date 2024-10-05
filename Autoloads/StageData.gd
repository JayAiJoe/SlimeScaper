extends Node

enum TERRAIN {DIRT, GRASS, ROCK, WATER}
enum SLIME {GRASS, WATER, ROCK, FIRE}

const LEVEL_DATA = {
	"garden1" : {
		"map" : {
			TERRAIN.ROCK:[Vector2(-6,3),Vector2(6,-3)],  #cauldrons
			TERRAIN.GRASS:[ Vector2(-3,-1),Vector2(-3,0),Vector2(-3,1),Vector2(-3,2),Vector2(-3,3),Vector2(-3,4),
							Vector2(-2,-2),Vector2(-2,-1),Vector2(-2,0),Vector2(-2,1),Vector2(-2,2),Vector2(-2,3),Vector2(-2,4),
							Vector2(-1,-2),Vector2(-1,-1),Vector2(-1,0),Vector2(-1,1),Vector2(-1,2),Vector2(-1,3),
							Vector2(0,-3),Vector2(0,-2),Vector2(0,-1),Vector2(0,0),Vector2(0,1),Vector2(0,2),Vector2(0,3),
							Vector2(1,-3),Vector2(1,-2),Vector2(1,-1),Vector2(1,0),Vector2(1,1),Vector2(1,2),
							Vector2(2,-4),Vector2(2,-3),Vector2(2,-2),Vector2(2,-1),Vector2(2,0),Vector2(2,1),Vector2(2,2),
							Vector2(3,-4),Vector2(3,-3),Vector2(3,-2),Vector2(3,-1),Vector2(3,0),Vector2(3,1),],
			TERRAIN.DIRT:[  Vector2(-6,2),Vector2(-6,4),
							Vector2(-5,1),Vector2(-5,2),Vector2(-5,3),Vector2(-5,4),
							Vector2(-4,0),Vector2(-4,1),Vector2(-4,2),Vector2(-4,3),Vector2(-4,4),
							Vector2(4,0),Vector2(4,-1),Vector2(4,-2),Vector2(4,-3),Vector2(4,-4),
							Vector2(5,-1),Vector2(5,-2),Vector2(5,-3),Vector2(5,-4),
							Vector2(6,-2),Vector2(6,-4),],
		},
		"player_start_positions" : [Vector2(-4,2),Vector2(4,-2)],
		"num_slimes" : 6,
	},
	"tutorial" : {
		"map" : {
			TERRAIN.ROCK:[Vector2(-3,0),Vector2(3,-3)],
			TERRAIN.GRASS:[ Vector2(0,0),Vector2(0,1),Vector2(0,2),Vector2(0,3),],
			TERRAIN.DIRT:[  Vector2(-4,1),Vector2(-4,2),Vector2(-4,3),
							Vector2(-3,0),Vector2(-3,1),Vector2(-3,2),Vector2(-3,3),
							Vector2(-2,-1),Vector2(-2,0),Vector2(-2,1),Vector2(-2,2),Vector2(-2,3),
							Vector2(-1,-1),Vector2(-1,0),Vector2(-1,1),Vector2(-1,2),Vector2(-1,3),
							Vector2(0,-1),
							Vector2(1,-2),Vector2(1,-1),Vector2(1,0),Vector2(1,1),Vector2(1,2),
							Vector2(2,-3),Vector2(2,-2),Vector2(2,-1),Vector2(2,0),Vector2(2,1),
							Vector2(3,-2),Vector2(3,-1),Vector2(3,0),
							Vector2(4,-1),Vector2(4,-2),Vector2(4,-3),],
			TERRAIN.WATER:[ Vector2(-1,-2),Vector2(0,-2),Vector2(0,-3),Vector2(1,-3),]
		},
		
		"player_start_positions" : [Vector2(-3,2),Vector2(3,-1)]
	},
}
