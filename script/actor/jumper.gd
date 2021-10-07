extends Sprite

export (float, 1.5, 10.0) var power

func _on_trigger_body_shape_entered(_body_id, body, _body_shape, _local_shape):
	$anim.play("process")
	
	if body.has_method("jumper"):
		body.call("jumper", power)
