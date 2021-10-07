tool
extends "res://script/scene_base.gd"

export (PackedScene) var next_scene
export (float) var show_duration = 3.0

enum {SPLASH_INIT, SPLASH_PROCESS, SPLASH_DONE}

var time = 0.0
var state = SPLASH_INIT

signal splash_start

func _ready():
	set_process(not Engine.editor_hint)

func _process(delta):
	match state:
		SPLASH_INIT:
			if $post_effect.completed():
				state = SPLASH_PROCESS
				emit_signal("splash_start")
				
		SPLASH_PROCESS:
			time += delta
			
			if time >= show_duration:
				state = SPLASH_DONE
				
				if next_scene:
					change_scene(next_scene)

func _input(event):
	if not (event is InputEventMouseMotion) and state != SPLASH_DONE:
		time = show_duration
