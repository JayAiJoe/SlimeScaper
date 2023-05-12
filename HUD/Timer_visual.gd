extends TextureProgressBar

func sync(timer_left):
	$clock_hand.set_rotation(-timer_left/5*2*PI)
