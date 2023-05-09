extends Node2D
class_name Slime

var current_coord
var animating = false

const JUMP_VELOCITY = -350.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var velocity_y = 0

var type = GameData.SLIME.GRASS

var aggro = null # which player
var los : Array = []
var vision_range : int = 2
var smellos : Array = []
var smell_range : int = 1

var max_move_time = 1.2
var min_move_time = 0.45
var move_time_scale = 0.8
#if speed carries over to new aggro, make scale higher for more incentive to steal

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer

signal landed(coords, type)


func _ready():
	set_type(type)
	set_z_index(1000)

func set_starting_position(pos : Vector2) -> void:
	current_coord = pos
	Utils.map.grid[pos].entity = self
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
	if not new_coord in Utils.map.grid:
		return
	change_coord(new_coord)
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(set_animating.bind(false))
	set_animating(true)
	tween.tween_property(self, "position", Utils.map.grid[current_coord].get_top_pos(), 0.4)
	velocity_y = JUMP_VELOCITY
	tween.tween_callback(emit_signal.bind("landed", current_coord, type))
	tween.tween_callback(update_los.bind(current_coord))

func set_animating(val : bool) -> void:
	animating = val

func change_coord(new_pos : Vector2) -> void:
	Utils.map.grid[current_coord].entity = null
	current_coord = new_pos
	Utils.map.grid[current_coord].entity = self

func update_los(coords : Vector2) -> void:
	var old_los = los
	los = Utils.get_coords_in_radius(coords, vision_range, false)
#	Utils.map.highlight_tiles(los)
#	for coord in old_los:
#		if not coord in los:
#			if coord in Utils.map.grid:
#				Utils.map.grid[coord].will_highlight(false)
	
	smellos = Utils.get_coords_in_radius(coords, smell_range, false)

func set_aggro(new_target) -> void:
	aggro = new_target
	if aggro == null:
		$MoveTimer.stop()
		$MoveTimer.set_wait_time(max_move_time)
		print("LOSE AGGRO")
	else:
		$MoveTimer.start()

func get_aggro_direction() -> String:
	var chosen_direction = ""
	if aggro.current_coord in los:
		var player_dir = current_coord.direction_to(aggro.current_coord)
		for dir in GameData.DIRECTION_NAMES:
			if player_dir == dir.normalized():
				chosen_direction = GameData.DIRECTION_NAMES[dir]
				return chosen_direction
		
		#in vision but not direct line
		var smell_dir = get_smell_dir()
		var biased_dir = smell_dir + player_dir
		chosen_direction = GameData.DIRECTION_NAMES[Utils.find_closest_dir(biased_dir)]
	else:
		set_aggro(null)
	return chosen_direction

func get_smell_dir() -> Vector2:
	var dir_num = 0
	var dir_total = Vector2(0,0)
	for coord in smellos:
		if coord in Utils.map.grid:
			dir_total = current_coord.direction_to(coord) * Utils.map.grid[coord].trail_level
			dir_num += 1
	
	if dir_num == 0:
		return dir_total
	return dir_total / dir_num

func is_free_tile(new_coords : Vector2) -> bool:
	for slime in get_tree().get_nodes_in_group("Slimes"):
		if slime != self and slime.current_coord == new_coords:
			return false
	return true

func _on_move_timer_timeout():
	var direction = get_aggro_direction()
	if direction != "":
		move_dir(direction)
		$MoveTimer.set_wait_time(max($MoveTimer.wait_time*move_time_scale, min_move_time))
		print($MoveTimer.wait_time)
