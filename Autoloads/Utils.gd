extends Node

const DIR = {   "move_SE": Vector2(1,0),
				"move_NE": Vector2(1,-1),
				"move_N" : Vector2(0,-1),
				"move_NW": Vector2(-1,0),
				"move_SW": Vector2(-1,1),
				"move_S" : Vector2(0,1),}
				
const TILE_WIDTH = 320
const TILE_LENGTH = 103
const TILE_THICK = 18

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

func coordinates_to_global(coordinates:Vector2, scale = Vector2(320/2,107/2)) -> Vector2:
	return Vector2( SCREEN_CENTER.x + (3/2 * coordinates.x                                 ) * scale.x,
					SCREEN_CENTER.y + (sqrt(3)/2 * coordinates.x + sqrt(3) * coordinates.y ) * scale.y)
