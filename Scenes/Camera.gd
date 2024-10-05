extends Camera2D


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.connect("resize_camera", adjust_camera)

func adjust_camera(cam_pos, cam_zoom):
	set_position(cam_pos)
	set_zoom(cam_zoom)
	$TextureRect.position = -Vector2(1920,1080) / cam_zoom.x / 2
	$TextureRect.scale = Vector2.ONE * (1/cam_zoom.x)
