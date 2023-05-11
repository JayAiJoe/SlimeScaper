extends TextureProgressBar

func _ready():
	Events.connect("update_ticker", sync)

func sync(timer_left):
	$clock_hand.set_rotation(-timer_left/5*2*PI)
