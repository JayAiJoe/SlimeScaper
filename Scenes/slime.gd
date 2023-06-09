extends Node2D
class_name Slime

var current_coord
var animating = false

const JUMP_VELOCITY = -350.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 2
var velocity_y = 0

var type = GameData.SLIME.GRASS

var aggro : Player = null # which player
var los : Array = []
var vision_range : int = 4
var smellos : Array = []
var smell_range : int = 1

var max_move_time = 0.2
var min_move_time = 0.2
var move_time_scale = 0.1
var to_free = false

#if speed carries over to new aggro, make scale higher for more incentive to steal

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_player = $AnimationPlayer

signal landed(coords, type)

func _ready():
	set_type(type)
	set_z_index(1000)
	
	$MoveTimer.set_wait_time(max_move_time)

func set_starting_position(pos : Vector2) -> void:
	current_coord = pos
	Utils.map.grid[pos].entity = self
	set_position(Utils.coordinates_to_global(current_coord))
	update_los(current_coord)

func _physics_process(delta):
	pass
#	if type != GameData.SLIME.FIRE:
#		return
#	if velocity_y != 0:
#		velocity_y += + gravity * delta
#		sprite.offset.y = min(0, sprite.offset.y + velocity_y * delta)
#		if sprite.offset.y == 0:
#			velocity_y = 0

func set_type(type_code : int) -> void:
	type = type_code
	play_animation("idle")
	#sprite.set_texture(GameData.INGREDIENT_TEXTURES[type])

func move_dir(dir_prio : Array) -> void:
	if animating:
		return
	var new_coord
	var found = false
	for dir in dir_prio:
		new_coord = current_coord + GameData.DIRECTIONS[dir]
		if not is_free_tile(new_coord):
			continue
		elif Utils.map.grid[new_coord].entity is Slime: # may laman
			continue
		else:
			found = true
			break
	
	if Utils.map.grid[new_coord].entity is Player: # may laman
		return
	if not found:
		return
	
	if type != GameData.SLIME.FIRE:
		if (new_coord-current_coord).x == -1:
			$Sprite2D.set_flip_h(true)
		elif (new_coord-current_coord).x == 1:
			$Sprite2D.set_flip_h(false)
	else:
		if (new_coord-current_coord).x == -1:
			$Sprite2D.set_flip_h(false)
		elif (new_coord-current_coord).x == 1:
			$Sprite2D.set_flip_h(true)
		
	change_coord(new_coord)
	var tween = get_tree().create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_QUAD)
	tween.finished.connect(set_animating.bind(false))
	set_animating(true)
	tween.tween_property(self, "position", Utils.map.grid[current_coord].get_top_pos(), 0.2)
	
	var action = "walk"
	if to_free:
		if type == GameData.SLIME.FIRE:
			play_animation("eat")
		else:
			play_animation("walk")
		tween.tween_callback(absorb)
		tween.tween_callback(queue_free)
	else:
		play_animation("walk")
		tween.tween_callback(emit_signal.bind("landed", current_coord, type))
		tween.tween_callback(update_los.bind(current_coord))
	
	
func absorb():
	Events.emit_signal("slime_absorbed", self)

func set_animating(val : bool) -> void:
	animating = val

func play_animation(action:String):
	animation_player.play(GameData.INGREDIENT_NAMES[type]+"_"+action)

func half_move(a)->Vector2:
	return (Utils.map.grid[current_coord].get_top_pos() +a)/2

func animate_invalid_move(global_pos:Vector2):
	var tween = get_tree().create_tween()
	tween.finished.connect(set_animating.bind(false))
	set_animating(true)
	tween.tween_property(self, "position", global_pos, $MoveTimer.wait_time/2)
	tween.tween_property(self, "position", Utils.map.grid[current_coord].get_top_pos(), $MoveTimer.wait_time/2)

func change_coord(new_pos : Vector2) -> void:
	Utils.map.grid[current_coord].leave()
	current_coord = new_pos
	Utils.map.grid[current_coord].occupy(self)

func cauldron_check() -> void:
	for new_coord in Utils.get_coords_in_radius(current_coord,1,false):
		if new_coord in Utils.map.grid:
			if Utils.map.grid[new_coord].tile_type == GameData.TERRAIN.ROCK:
				jump_to_cauldron(new_coord-current_coord)
				break

func jump_to_cauldron(dir:Vector2) -> void:
	move_dir([GameData.DIRECTION_NAMES[dir]])

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
		$Sprite2D.set_modulate(Color(1,1,1))
		$Sprite2D.material.set("shader_param/line_thickness", 0)
	else:
		$MoveTimer.start()
		$Sprite2D.set_modulate(GameData.COLORS[aggro.player_color])
		$Sprite2D.material.set("shader_param/line_color", GameData.COLORS[aggro.player_color])
		$Sprite2D.material.set("shader_param/line_thickness", 2)

func get_aggro_direction() -> Array:
	var direction_prio = []
	var pheromones_prio = []
	var i = 0
	if aggro.current_coord in los:
		var current_pher = Utils.map.get_pheromone_level(aggro.player_color, current_coord)
		var dirs = GameData.DIRECTION_NAMES.keys()
		dirs.shuffle()
		for coord in dirs:
			var new_coord = current_coord + coord
			if new_coord in Utils.map.grid:
				var new_pher = Utils.map.get_pheromone_level(aggro.player_color, new_coord)
				if new_pher < current_pher:
					continue
				i = 0
				while i < direction_prio.size() and new_pher < pheromones_prio[i]:
					i += 1
				direction_prio.insert(i, GameData.DIRECTION_NAMES[coord])
				pheromones_prio.insert(i, new_pher)
	else:
		set_aggro(null)
	return direction_prio


func is_free_tile(new_coords : Vector2) -> bool:
	for slime in get_tree().get_nodes_in_group("Slimes"):
		if slime != self and slime.current_coord == new_coords:
			return false
	return true

func _on_move_timer_timeout():
	cauldron_check()
	var direction_prio = get_aggro_direction()
	if direction_prio != []:
		move_dir(direction_prio)
		$MoveTimer.set_wait_time(max($MoveTimer.wait_time*move_time_scale, min_move_time))
		#print($MoveTimer.wait_time)

func trigger_free():
	to_free = true

func _on_animation_player_animation_finished(anim_name):
	await get_tree().create_timer(randf_range(1,3)).timeout
	play_animation("idle")
