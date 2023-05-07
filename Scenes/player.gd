extends Node2D

const DIR = {   "move_SE": Vector2(1,0),
				"move_NE": Vector2(1,-1),
				"move_N" : Vector2(0,-1),
				"move_NW": Vector2(-1,0),
				"move_SW": Vector2(-1,1),
				"move_S" : Vector2(0,1),}

var current_coord
var animating = false


func _ready():
	set_z_index(1000)
	
	Utils.set_screen_rect(get_viewport_rect())
	current_coord = Vector2(0,0)
	set_position(Utils.coordinates_to_global(current_coord))

func _input(event):
	for dir in DIR:
		if event.is_action_pressed(dir):
			move_dir(dir)

func move_dir(dir):
	if animating:
		return
	var new_coord = current_coord + DIR[dir]
	if not new_coord in Utils.grid.grid:
		return
	current_coord = new_coord
	var tween = get_tree().create_tween()
	tween.finished.connect(set_animating.bind(false))
	set_animating(true)
	tween.tween_property(self, "position", Utils.grid.grid[current_coord].get_top_pos(), 0.4)

func set_animating(val : bool) -> void:
	animating = val


