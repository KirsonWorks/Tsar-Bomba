tool
extends TileMap

enum Function {NONE, SIN, COS}

export (bool) var has_inner_trigger = false
export (Function) var x_function
export (Function) var y_function
export (float) var speed = 1.0
export (float) var value = 0.0

const INNER_SHRINK = 8

var time = 0.0
var initial_pos: Vector2

func _ready():
	initial_pos = position
	set_process(not Engine.editor_hint)
	
	if has_inner_trigger and not Engine.editor_hint:
		create_inner_trigger()

func reset():
	time = 0.0
	position = initial_pos

func evaluate_function(function, time, value):
	match function:
		Function.SIN:
			return sin(time) * value
		
		Function.COS:
			return cos(time) * value

		_:
			return 0.0

func _process(delta):
	position.x += evaluate_function(x_function, time * speed, value) * delta
	position.y += evaluate_function(y_function, time * speed, value) * delta
	time += delta
	
func _on_inner_body_shape_entered(body_id, body, body_shape, local_shape):
	if body is KinematicBody2D:
		if body.has_method("kill"):
			body.call("kill")

func create_inner_trigger():
	var rect = get_used_rect()
	var trigger = Area2D.new()
	var collider = CollisionShape2D.new()
	var shape = RectangleShape2D.new()
	
	add_child(trigger)
	trigger.add_child(collider)
	trigger.connect("body_shape_entered", self, "_on_inner_body_shape_entered")
	trigger.collision_mask = 0
	trigger.collision_layer = 2
	
	rect = Rect2(rect.position * cell_size.x, rect.size * cell_size.y)
	shape.extents = rect.size / 2 - Vector2(INNER_SHRINK, INNER_SHRINK)
	collider.position = rect.position + rect.size / 2
	collider.shape = shape
