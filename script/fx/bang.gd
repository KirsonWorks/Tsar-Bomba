tool
extends CanvasLayer

signal completed()

func _ready():
	randomize()

func is_shown():
	return $anim.is_playing()

func hide():
	$anim.play("hide")

func bang(position):
	var vp_size = get_viewport().get_size_override()
	$texture.material.set_shader_param("pos", position / vp_size)
	$anim.play("bang")

func banger(range_x, range_y, times):
	for _i in range(times):
		var pos = Vector2(rand_range(range_x.x, range_x.y),
				rand_range(range_y.x, range_y.y))
		$texture.material.set_shader_param("pos", pos)
		$anim.play("firework")
		yield(self, "completed")
	
	hide()

func _on_animation_finished(_anim_name):
	emit_signal("completed")
