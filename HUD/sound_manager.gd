extends Node2D

@onready var player_1 = $AudioStreamPlayer
@onready var player_2 = $AudioStreamPlayer2
@onready var player_general = $AudioStreamPlayer3
@onready var bg_player = $BGMusic

var allow_sound : bool = true

var sounds = {
	"grass_step" : [preload("res://Assets/sounds/grass_blue.mp3"), preload("res://Assets/sounds/grass_red.mp3")],
	"tile_step" : [preload("res://Assets/sounds/tile_blue.ogg"), preload("res://Assets/sounds/tile_red.ogg")],
	"ping" : [preload("res://Assets/sounds/ping.mp3")],
	"chomp" : [preload("res://Assets/sounds/chomp.mp3"), preload("res://Assets/sounds/chomp.mp3")],
	"drop" : [preload("res://Assets/sounds/drop.mp3"), preload("res://Assets/sounds/drop.mp3")],
	"boom" : [preload("res://Assets/sounds/boom.mp3"), preload("res://Assets/sounds/boom.mp3")],
}

func _ready():
	bg_start()
	set_music_level(-30)
	set_sound_level(0)

func play_sound(sound : String, color : String = "") -> void:
	print(sound)
	if not allow_sound:
		return
	var idx = 0
	var current_player : AudioStreamPlayer = player_general
	if color == "blue":
		current_player = player_1
	elif color == "red":
		current_player = player_2
		idx = 1
	if sound == "ping":
		current_player.pitch_scale = 0.9
		
	current_player.stream = sounds[sound][idx]
	current_player.play()
	await current_player.finished
	current_player.pitch_scale = 1.0

func _input(event):
	if event.is_action_pressed("ui_accept"):
		play_sound("ping")

func set_music_level(sound_level):
	bg_player.volume_db = sound_level
	if sound_level == -40:
		bg_player.stream_paused = true
	else:
		bg_player.stream_paused = false
	
func set_sound_level(sound_level):
	for i in range(3):
		get_child(i).volume_db = sound_level

func _on_bg_music_finished():
	bg_start()

func bg_start():
	bg_player.volume_db = -50
	bg_player.play()


