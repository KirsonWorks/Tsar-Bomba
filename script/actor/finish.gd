extends Sprite

signal reached()

var is_reached = false

func reset():
	is_reached = false

func _on_trigger_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if not is_reached and body is KinematicBody2D:
		is_reached = true
		emit_signal("reached")
