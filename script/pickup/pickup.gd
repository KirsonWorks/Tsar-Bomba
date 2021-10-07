tool
extends Sprite

func reset():
	active(true)
	
func collect():
	active(false)
	$snd_collect.play()
	
func active(value):
	visible = value
	$trigger.monitoring = value

func _on_trigger_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	if body is KinematicBody2D:
		var method = "pickup_%s" % name
		
		if body.has_method(method):
			body.call(method)
		
		call_deferred("collect")
