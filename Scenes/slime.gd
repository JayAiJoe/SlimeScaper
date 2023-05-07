extends Node2D

const DIR = {   "move_SE": Vector2(1,0),
				"move_NE": Vector2(1,-1),
				"move_N" : Vector2(0,-1),
				"move_NW": Vector2(-1,0),
				"move_SW": Vector2(-1,1),
				"move_S" : Vector2(0,1),}

var current_coord
var animating = false

const JUMP_VELOCITY = -350.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var velocity_y = 0

var type = GameData.SLIME_TYPES.GRASS

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer

signal landed(coords, type)


func _ready():
	set_type(type)
	set_z_index(1000)
	
	Utils.set_screen_rect(get_viewport_rect())
	current_coord = Vector2(1,0)
	set_position(Utils.coordinates_to_global(current_coord))
	
	#animation_player.play("idle")

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
	var new_coord = current_coord + DIR[dir]
	if not new_coord in Utils.grid.grid:
		return
	current_coord = new_coord
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(set_animating.bind(false))
	set_animating(true)
	tween.tween_property(self, "position", Utils.coordinates_to_global(current_coord), 0.4)
	velocity_y = JUMP_VELOCITY
	tween.tween_callback(emit_signal.bind("landed", current_coord, type))

func set_animating(val : bool) -> void:
	animating = val


