extends Label

var f = 2
var a = 0.4
var t = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	t += delta
	position.y += a*sin(f*t)
