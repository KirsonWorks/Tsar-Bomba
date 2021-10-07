extends "res://script/pickup/pickup.gd"

func reset():
	var stat = Global.current_stat()
	
	if not stat.apple_reached:
		.reset()
	else:
		active(false)
