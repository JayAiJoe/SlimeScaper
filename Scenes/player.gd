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

var round_started = false



@export var player_color = "blue"
var score = 0

@onready var sprite : Sprite2D = $Sprite2D


signal landed(color, coords)

func _ready():
	set_z_index(4096)
	Utils.player = self
	Events.emit_signal("points_gained",player_color,score)
	$Hat.set_modulate(GameData.COLORS[player_color])

func set_starting_position(pos : Vector2) -> void:
	current_coord = pos
	Utils.map.grid[pos].entity = self
	set_position(Utils.coordinates_to_global(current_coord))
	landed.emit(player_color, current_coord)

func _input(event):
	if round_started:
		for dir in GameData.DIRECTIONS:
			if event.is_action_pressed(player_color+"_"+dir):
				if move_queue.size() < move_queue_max:
					move_queue.append(dir)

func _process(delta):
	if not animating and move_queue.size() > 0:
		move_dir(move_queue.pop_front())

func _physics_process(delta):
	pass
#	if velocity_y != 0:
#		velocity_y += + gravity * delta
#		sprite.offset.y = min(0, sprite.offset.y + velocity_y * delta)
#		if sprite.offset.y == 0:
#			velocity_y = 0

func show_keys():
	for key in GameData.KEY_BINDS[player_color]:
		$KEYS.get_node(key).set_text(GameData.KEY_BINDS[player_color][key])
	$KEYS.show()

func move_dir(dir):
	if animating:
		return
	var new_coord = current_coord + GameData.DIRECTIONS[dir]
	if not new_coord in Utils.map.grid: # no tile
		animate_invalid_move(half_move(Utils.coordinates_to_global(new_coord)) )
		return
	if Utils.map.grid[new_coord].tile_type == GameData.TERRAIN.ROCK:
		animate_invalid_move(half_move(Utils.map.grid[new_coord].get_top_pos()))
		return
	if Utils.map.grid[new_coord].entity and Utils.map.grid[new_coord].entity is Slime: # may laman
		Utils.map.grid[new_coord].entity.set_aggro(self)
		animate_invalid_move(half_move(Utils.map.grid[new_coord].get_top_pos()))
		return
	elif Utils.map.grid[new_coord].entity is Player: # may laman
		animate_invalid_move(half_move(Utils.map.grid[new_coord].get_top_pos()))
		return
		
	change_coord(new_coord)
	
	var tween = get_tree().create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.finished.connect(set_animating.bind(false))
	set_animating(true)
	tween.tween_property(self, "position", Utils.map.grid[current_coord].get_top_pos(), MOVE_TIME)
	#velocity_y = JUMP_VELOCITY
	tween.tween_callback(emit_signal.bind("landed", player_color, current_coord))
	if Utils.map.grid[current_coord].tile_type == GameData.TERRAIN.GRASS:
		SoundManager.play_sound("grass_step", player_color)
	else:
		SoundManager.play_sound("tile_step", player_color)

func set_animating(val : bool) -> void:
	animating = val

func half_move(a)->Vector2:
	return (Utils.map.grid[current_coord].get_top_pos() +a)/2

func animate_invalid_move(global_pos:Vector2):
	var tween = get_tree().create_tween()
	tween.finished.connect(set_animating.bind(false))
	set_animating(true)
	tween.tween_property(self, "position", global_pos, MOVE_TIME/2)
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_property(self, "position", Utils.map.grid[current_coord].get_top_pos(), MOVE_TIME/2)

func change_coord(new_pos : Vector2) -> void:
	Utils.map.grid[current_coord].entity = null
	if Utils.map.grid[current_coord].tile_type == GameData.TERRAIN.WATER:
		Events.emit_signal("ready_player", -1)
	current_coord = new_pos
	Utils.map.grid[current_coord].entity = self
	if Utils.map.grid[current_coord].tile_type == GameData.TERRAIN.WATER:
		Events.emit_signal("ready_player", 1)

func add_score(gained_score : int):
	score += gained_score
	Events.emit_signal("points_gained",player_color,score)
