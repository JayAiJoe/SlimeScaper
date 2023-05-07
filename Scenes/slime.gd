extends Node2D
class_name Slime

var current_coord
var animating = false

const JUMP_VELOCITY = -350.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var velocity_y = 0


var type = GameData.SLIME.GRASS

var los : Array = []
var vision_range : int = 1

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer

signal landed(coords, type)


func _ready():
	set_type(type)
	set_z_index(1000)
	
	Utils.set_screen_rect(get_viewport_rect())
	

func set_starting_position(pos : Vector2) -> void:
	current_coord = pos
	set_position(Utils.coordinates_to_global(current_coord))
	update_los(current_coord)
	


func _input(event):
	if event.is_action_pressed("ui_up"):
		if Input.is_action_pressed("ui_left"):
			move_dir("move_NW")
		elif Input.is_action_pressed("ui_right"):
			move_dir("move_NE")
		else:
			move_dir("move_N")
	elif event.is_action_pressed("ui_down"):
		if Input.is_action_pressed("ui_left"):
			move_dir("move_SW")
		elif Input.is_action_pressed("ui_right"):
			move_dir("move_SE")
		else:
			move_dir("move_S")

func _physics_process(delta):
	if velocity_y != 0:
		velocity_y += + gravity * delta
		sprite.offset.y = min(0, sprite.offset.y + velocity_y * delta)
		if sprite.offset.y == 0:
			velocity_y = 0

func set_type(type_code : int) -> void:
	type = type_code
	sprite.set_texture(load("res://Assets/slimes/" + str(type) + ".png"))

func move_dir(dir : String) -> void:
	if animating:
		return
	var new_coord = current_coord + GameData.DIRECTIONS[dir]
	if not is_free_tile(new_coord):
		return
	if not new_coord in Utils.grid.grid:
		return
	current_coord = new_coord
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(set_animating.bind(false))
	set_animating(true)
	tween.tween_property(self, "position", Utils.coordinates_to_global(current_coord), 0.4)
	velocity_y = JUMP_VELOCITY
	tween.tween_callback(emit_signal.bind("landed", current_coord, type))
	tween.tween_callback(update_los.bind(current_coord))

func set_animating(val : bool) -> void:
	animating = val

func update_los(coords : Vector2) -> void:
	los = Utils.get_coords_in_radius(coords, vision_range, true)

func get_aggro_direction() -> String:
	var highest_trail_level = 0
	var chosen_direction = ""
	for coords in los:
		if coords in Utils.grid.grid:
			var current_tile = (Utils.grid.grid[coords] as Tile2D)
			if current_tile.trail_level > highest_trail_level:
					highest_trail_level = current_tile.trail_level
					chosen_direction = GameData.DIRECTION_NAMES[coords - current_coord]
	return chosen_direction

func is_free_tile(new_coords : Vector2) -> bool:
	for slime in get_tree().get_nodes_in_group("Slimes"):
		if slime != self and slime.current_coord == new_coords:
			return false
	return true


func _on_move_timer_timeout():
	var direction = get_aggro_direction()
	if direction != "":
		move_dir(direction)
