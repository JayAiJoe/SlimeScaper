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
