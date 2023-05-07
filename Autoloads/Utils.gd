extends Node


const TILE_WIDTH = 318
const TILE_HEIGHT = 103
const TILE_THICK = 16


var SCREEN_RECT 
var SCREEN_WIDTH
var SCREEN_HEIGHT
var SCREEN_CENTER

var grid

func set_screen_rect(rect):
	SCREEN_RECT = rect
	SCREEN_WIDTH = SCREEN_RECT.size.x
	SCREEN_HEIGHT = SCREEN_RECT.size.y
	SCREEN_CENTER = SCREEN_RECT.get_center()

func coordinates_to_global(coordinates:Vector2, scale = Vector2(TILE_WIDTH/2,TILE_HEIGHT/2)) -> Vector2:
	return Vector2( SCREEN_CENTER.x + (3/2 * coordinates.x                                 ) * scale.x,
					SCREEN_CENTER.y + (sqrt(3)/2 * coordinates.x + sqrt(3) * coordinates.y ) * scale.y)

func get_coords_in_ring(center:Vector2, radius:int) -> Array:
	var result = []
	var current = Vector2(-1,1)*radius + center
	
	for dir in GameData.DIRECTIONS:
		for i in range(radius):
			result.append(current)
			current += GameData.DIRECTIONS[dir]
	return result
	
func get_coords_in_radius(center:Vector2, radius:int, include_center = false) -> Array: 
	var results = []
	if include_center:
		results.append(center)
	for i in range(1,radius+1):
		results += get_coords_in_ring(center, i)
	return results
