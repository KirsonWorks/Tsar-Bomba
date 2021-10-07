tool
extends Control

class_name UISlot

export (bool) var updown_at_click = false

func _gui_input(event):
	if event is InputEventMouseMotion:
		return
		
	if updown_at_click and event.is_pressed():
		if event.button_index == BUTTON_LEFT:
			high()
		elif event.button_index == BUTTON_RIGHT:
			low()

func low():
	pass

func high():
	pass
