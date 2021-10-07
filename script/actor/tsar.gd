tool
extends KinematicBody2D

signal killed(pos)

export (float) var blink_start = 3.0
export (float, 1.0, 32.0) var blink_freq = 8.0

const GRAVITY = 35
const VEL_X_MAX = 390
const VEL_Y_MAX = 1250
const ACC_X = 340
const ACC_DROP_X = 2000
const ACC_JUMP = 112
const JUMP_LONGER_GRAVITY_SCALE = 0.15

var velocity = Vector2()
var acceleration = Vector2()

var direction = 0
var prev_direction = 0

var can_move = true
var is_jumping = false
var is_jump_longer = false
var is_jump_control = false
var current_anim = ""
var blink_time = 0.0
var has_apple = false

onready var anim = $sprite/anim

func reset(pos):
	direction = 0
	visible = true
	position = pos
	can_move = true
	current_anim = ""
	is_jumping = false
	is_jump_longer = false
	velocity = Vector2()
	acceleration = Vector2()
	blink_time = INF
	blink_state(false)
	has_apple = false

func stay():
	can_move = false

func move_left():
	if can_move:
		direction = -1

func move_right():
	if can_move:
		direction = 1

func kill():
	if not visible:
		return

	direction = 0
	visible = false
	animation("idle")
	var tform = get_global_transform_with_canvas()
	emit_signal("killed", tform.origin)

func animation(name):
	if current_anim != name:
		anim.play(name)
		current_anim = name

func takeoff(accel):
	animation("jump")
	is_jumping = true
	
	if acceleration.y > -accel:
		acceleration.y = -accel

func jump():
	if not can_move:
		return

	is_jump_longer = is_jumping
	
	if is_on_floor():
		is_jump_control = true
		takeoff(ACC_JUMP)

func jumper(power):
	is_jump_control = false
	var acc_scale = velocity.y / float(VEL_Y_MAX) * power + 1.0
	takeoff(ACC_JUMP * acc_scale)
	velocity.y = 0

func fall():
	animation("fall")
	acceleration.y = 0
	is_jumping = false
	is_jump_longer = false

func blink_state(enabled):
	$sprite.material.blend_mode = \
			BLEND_MODE_ADD \
			if enabled else \
			BLEND_MODE_MIX

func pickup_apple():
	has_apple = true

func _process(_delta):
	if not visible:
		return
		
	if blink_time <= blink_start:
		var time = 1.0 - blink_time / blink_start
		var freq = blink_freq * time + 1.0
		var value = int(stepify(fposmod(time, 1.0 / freq) * freq, 0.5))
		blink_state(value == 1 and can_move)

func _physics_process(delta):
	if not visible or Engine.editor_hint:
		return
	
	var is_moving = direction != 0
	
	if is_moving:
		$sprite.flip_h = direction < 0
		
		if prev_direction != direction:
			prev_direction = direction
		
		acceleration.x = ACC_X * direction
	else:		
		var xvel = abs(velocity.x)
		xvel -= ACC_DROP_X * delta
		
		if xvel < 0:
			xvel = 0
		
		velocity.x = xvel * prev_direction
		acceleration.x = 0

	if is_jumping:
		if acceleration.y < 0:
			var gscale = JUMP_LONGER_GRAVITY_SCALE \
					if is_jump_control and is_jump_longer else 1.0
			acceleration.y += GRAVITY * gscale
		else:
			fall()

		is_jump_longer = false
	else:
		acceleration.y = GRAVITY
		
	velocity += acceleration
	velocity.x = clamp(velocity.x, -VEL_X_MAX, VEL_X_MAX)
	velocity.y = min(velocity.y, VEL_Y_MAX)
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if is_jumping and is_on_ceiling():
		var collider = get_slide_collision(0)
		
		if collider is KinematicCollision2D:
			fall()
	
	if is_on_floor():
		animation("run" if is_moving else "idle") 
	elif not is_jumping:
		animation("fall")
		
	direction = 0
