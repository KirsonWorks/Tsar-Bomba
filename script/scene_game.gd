tool
extends "res://script/scene_base.gd"

export (String) var debug_map_name = ""

enum State { SLEEP, RUN, BANG, GAMEOVER, WIN }

var map = null
var state = State.SLEEP
var current_spawn = Vector2()

onready var tsar = $tsar
onready var bang = $bang
onready var countdown = $countdown

func _ready():
	set_process(not Engine.editor_hint)
	
	if OS.is_debug_build() and not debug_map_name.empty():
		load_map(debug_map_name)
	else:
		load_map(Global.map_name)
	
func restart():
	assert(map)
	assert(tsar)

	state = State.SLEEP
	countdown.hide()
	bang.hide()
	map.reset()
	tsar.reset(current_spawn)

func run():
	state = State.RUN
	countdown.show()
	countdown.reset(current_spawn)
	map.reset_time()

func win():
	state = State.WIN
	tsar.stay()
	$snd_tada.play()
	bang.banger(Vector2(0.2, 0.8), Vector2(0.2, 0.5), 5)

func load_map(map_name: String):
	if map_name == "map-last" and \
			not Global.all_maps_full_completed():
				map_name = ""
			
	if map_name.empty():
		change_scene("res://scene/scene_menu.tscn")
		Global.save_game()
		return
		
	if map:
		map.queue_free()

	Global.save_game(map_name)
	
	map = load("res://scene/map/%s.tscn" % map_name).instance()
	map.set_camera_limit(tsar.get_node("camera"))
	map.connect("completed", self, "_on_map_completed")
	map.connect("timeout", self, "_on_map_timeout")
	current_spawn = map.get_spawn_position()
	
	add_child(map)
	move_child(map, 0)
	restart()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.is_action("ui_cancel"):
			change_scene("res://scene/scene_menu.tscn")
			return
			
		match state:
			State.SLEEP:
				run()

			State.GAMEOVER:
				restart()
			
func _process(_delta):
	if state == State.RUN:
		countdown.update_value(map.time_left)
		tsar.blink_time = map.time_left

func _physics_process(_delta):
	if Engine.editor_hint:
		return

	if state == State.RUN:
		if Input.is_action_just_pressed("restart"):
			restart()
			return
		
		if Input.is_action_pressed("move_left"):
			tsar.move_left()
		elif Input.is_action_pressed("move_right"):
			tsar.move_right()

		if Input.is_action_pressed("jump"):
			tsar.jump()
		
		if OS.is_debug_build():
			if Input.is_action_just_released("set_spawn"):
				current_spawn = tsar.position
			
			if Input.is_action_just_released("reset_spawn"):
				current_spawn = map.get_spawn_position()
			
			if Input.is_action_just_pressed("freeze_countdown"):
				map.time_freeze = INF

func _on_tsar_killed(pos):
	state = State.BANG
	bang.bang(pos)
	yield(bang, "completed")
	restart()

func _on_map_completed():
	win()
	yield(get_tree().create_timer(3.0), "timeout")
	
	var elapsed = map.time_sec - map.time_left
	Global.update_stat(elapsed, tsar.has_apple)
	var stat = Global.current_stat()
	
	$ui/dialog_result.execute(map.time_sec, map.time_left, stat.best_time,
			stat.apple_reached)

func _on_map_timeout():
	tsar.kill()

func _on_dialog_result_continue_action():
	load_map(map.next_map)

func _on_dialog_result_repeat_action():
	restart()
