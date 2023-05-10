extends Node

const TILE_WIDTH = 318
const TILE_HEIGHT = 103
const TILE_THICK = 16

var SCREEN_RECT 
var SCREEN_WIDTH = 1920
var SCREEN_HEIGHT = 1080
var SCREEN_CENTER = Vector2(SCREEN_WIDTH/2,SCREEN_HEIGHT/2)

var map
var player

func ready():
	SCREEN_RECT = Rect2(0,0,get("display/width"),get("display/height"))
	SCREEN_WIDTH = SCREEN_RECT.size.x
	SCREEN_HEIGHT = SCREEN_RECT.size.y
	SCREEN_CENTER = SCREEN_RECT.get_center()

func coordinates_to_global(coordinates:Vector2, tile_size = Vector2(TILE_WIDTH/2,TILE_HEIGHT/2)) -> Vector2:
	return Vector2( SCREEN_CENTER.x + (3/2 * coordinates.x                                  ) * tile_size.x,
					SCREEN_CENTER.y + (sqrt(3)/2 * coordinates.x + sqrt(3) * coordinates.y ) * tile_size.y)


func get_coords_in_ring(center:Vector2, radius:int, include_center = false) -> Array:
	var result = []
	var current = Vector2(-1,1)*radius + center
	
	if include_center:
		result.append(center)
	
	for dir in GameData.DIRECTIONS:
		for i in range(radius):
			result.append(current)
			current += GameData.DIRECTIONS[dir]
	return result
	
func get_coords_in_radius(center:Vector2, radius:int, include_center = false) -> Array: 
	var result = []
	
	if include_center:
		result.append(center)
		
	for i in range(1,radius+1):
		result += get_coords_in_ring(center, i)
	return result

func find_closest_dir(d:Vector2) -> Vector2:
	var closest = Vector2(0,0)
	var closest_angle = -1
	
	var transformed_d = Vector2(cos(PI/6)*d.x,-0.5*d.x+d.y)
	for dir in GameData.DIRECTION_NAMES:
		var angle = dir.dot(transformed_d)
		if angle > closest_angle: 
			closest = dir
			closest_angle = angle
	return closest

func get_closest_dirs_array(angle) -> Array:
	var result = []
	var angles = []
	var i = 0
	for dir in GameData.DIRECTION_NAMES:
		var dir_angle = GameData.DIR_TO_ANGLE[dir]
		var diff = min(abs(angle-dir_angle),abs(angle+360-dir_angle))
		i = 0
		while i < angles.size() and angles[i]<diff:
			i+=1
		result.insert(i,GameData.DIRECTION_NAMES[dir])
		angles.insert(i,diff)
	return result
