extends Node

signal resize_camera(cam_pos, cam_zoom)
signal global_tick()
signal update_ticker(time_left)
signal points_gained(player_color, new_points)
signal slime_absorbed(slime)
signal ready_player(delta)

func _ready():
	pass # Replace with function body.
