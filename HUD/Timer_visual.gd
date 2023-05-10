extends TextureProgressBar

func _ready():
	Events.connect("update_ticker", sync)

func sync(timer_left):
	set_value(timer_left)
