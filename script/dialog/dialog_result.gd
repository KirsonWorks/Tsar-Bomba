tool
extends NinePatchRect

signal repeat_action
signal continue_action

func execute(time_overall, time_left, time_best, has_apple):
	$time_elapsed_value.text = "%.2f / %.1f %s" % [time_overall - time_left, time_overall, tr("Sec")]
	$time_left_value.text = "%.3f %s" % [time_left, tr("Sec")]
	$time_best_value.text = "%.2f %s" % [time_best, tr("Sec")]
	$apple_value.text = tr("Yes") if has_apple else tr("No")
	show()

func _on_item_repeat_action():
	emit_signal("repeat_action")
	hide()

func _on_item_continue_action():
	emit_signal("continue_action")
	hide()
