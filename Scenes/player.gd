extends Node2D
class_name Player


const MOVE_TIME = 0.25

var current_coord
var animating = false

const JUMP_VELOCITY = -400.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3
var velocity_y = 0

var move_queue : Array = []
var move_queue_max : int = 1

@onready var sprite : Sprite2D = $Sprite2D

signal landed(coords)


func _ready():
	set_z_index(1000)

	set_starting_position(Vector2.ZERO)
	Utils.player = self

func set_starting_position(pos : Vector2) -> void:
	current_coord = pos
	set_position(Utils.coordinates_to_global(current_coord))
	landed.emit(current_coord)

func _input(event):
	for dir in GameData.DIRECTIONS:
		if event.is_action_pressed(dir):
			if move_queue.size() < move_queue_max:
				move_queue.append(dir)

func _process(delta):
	if not animating and move_queue.size() > 0:
		move_dir(move_queue.pop_front())

func _physics_process(delta):
	if velocity_y != 0:
		velocity_y += + gravity * delta
		sprite.offset.y = min(0, sprite.offset.y + velocity_y * delta)
		if sprite.offset.y == 0:
			velocity_y = 0

func move_dir(dir):
	if animating:
		return
	var new_coord = current_coord + GameData.DIRECTIONS[dir]
	if not new_coord in Utils.grid.grid:
		return
	current_coord = new_coord
	var tween = get_tree().create_tween()
	tween.finished.connect(set_animating.bind(false))
	set_animating(true)
	tween.tween_property(self, "position", Utils.grid.grid[current_coord].get_top_pos(), MOVE_TIME)
	velocity_y = JUMP_VELOCITY
	tween.tween_callback(emit_signal.bind("landed", current_coord))

func set_animating(val : bool) -> void:
	animating = val

