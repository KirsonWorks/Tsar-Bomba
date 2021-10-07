tool
extends TileMap

export (String) var next_map

signal completed()
signal timeout()

export (float) var time_sec = 10.1

var time_left = 0.0
var time_freeze = 0.0

func _ready():
	set_process(not Engine.editor_hint)

func reset():
	time_freeze = INF
	get_tree().call_group("resettable", "reset")

func reset_time():
	time_left = time_sec
	time_freeze = 0.0

func complete():
	if time_left > 0.0:
		time_freeze = INF
		emit_signal("completed")

func get_spawn_position():
	return $spawn.position

func set_camera_limit(camera: Camera2D):
	assert(camera)
	
	var rect = get_used_rect()
	camera.limit_left = rect.position.x * cell_size.x
	camera.limit_top = rect.position.y * cell_size.y
	camera.limit_right = rect.end.x * cell_size.x
	camera.limit_bottom = rect.end.y * cell_size.y

func _process(delta):
	if time_freeze <= 0.0:
		if time_left > 0.0:
			time_left -= delta
		
			if time_left <= 0.0:
				time_left = 0.0
				emit_signal("timeout")
	else:
		time_freeze -= delta

func _on_finish_reached():
	complete()
