extends Sprite2D
class_name Tile2d


var coordinates  = Vector2(0,0)
var state = "dirt"

func _ready():
	pass # Replace with function body.

func init(_coordinates = Vector2(0,0), _state = "undefined"):
	coordinates = _coordinates
	set_z_index(coordinates.y)
	state = _state