tool
extends Label

export (NodePath) var target_path
export (float, 1.0, 20.0) var follow_speed
export (Vector2) var offset = Vector2.ZERO
export (float) var visible_start = 10.0 setget _set_visible_start
export (float) var visible_end = 0.09 setget _set_visible_end
export (float) var real_start = 3.0
	
func _process(delta):
	var target = get_node_or_null(target_path)
	
	if target:
		assert(target is Node2D)
		var rpos = rect_global_position
		var tpos = target.global_position + offset

		rpos = rpos.linear_interpolate(tpos, delta * follow_speed)
		set_global_position(rpos)

func _set_visible_start(value):
	if value < visible_end:
		value = visible_end
	
	visible_start = value
	
func _set_visible_end(value):
	if value > visible_start:
		value = visible_start
	
	visible_end = value

func reset(position):
	set_position(position)

func update_value(value : float):
	var value_text = ""
	
	if value >= visible_end and value <= visible_start:
		var format = "%.1f" if value < real_start else "%.0f"
		value_text = format % value

	text = value_text
