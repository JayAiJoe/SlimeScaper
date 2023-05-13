extends Node2D

@onready var player_1 = $AudioStreamPlayer
@onready var player_2 = $AudioStreamPlayer2
@onready var player_general = $AudioStreamPlayer3


var sounds = {
	"grass_step" : [preload("res://Assets/sounds/grass_blue.ogg"), preload("res://Assets/sounds/grass_red.ogg")],
	"tile_step" : [preload("res://Assets/sounds/tile_blue.ogg"), preload("res://Assets/sounds/tile_red.ogg")],
	"ping" : [preload("res://Assets/sounds/ping.mp3")],
	"chomp" : [preload("res://Assets/sounds/chomp.mp3"), preload("res://Assets/sounds/chomp.mp3")]
}

func play_sound(sound : String, color : String = "") -> void:
	var idx = 0
	var current_player : AudioStreamPlayer = player_general
	if color == "blue":
		current_player = player_1
	elif color == "red":
		current_player = player_2
		idx = 1
	current_player.stream = sounds[sound][idx]
	current_player.play()
	
	
