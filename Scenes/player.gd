extends Node2D



var current_coord
var animating = false

const JUMP_VELOCITY = -350.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var velocity_y = 0

@onready var sprite : Sprite2D = $Sprite2D

signal landed(coords)


func _ready():
	set_z_index(1000)
	
	Utils.set_screen_rect(get_viewport_rect())
	current_coord = Vector2(0,0)
	set_position(Utils.coordinates_to_global(current_coord))

func _input(event):
	for dir in GameData.DIRECTIONS:
		if event.is_action_pressed(dir):
			move_dir(dir)

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
	tween.tween_property(self, "position", Utils.grid.grid[current_coord].get_top_pos(), 0.4)
	velocity_y = JUMP_VELOCITY
	tween.tween_callback(emit_signal.bind("landed", current_coord))

func set_animating(val : bool) -> void:
	animating = val

