extends KinematicBody2D

const MAX_SPEED = 500
const GRAVITY = 10

# Physics Var
var dir = Vector2()
var speed = Vector2()
var player_pos = Vector2()

# Velocity is MAX_SPEED * power (from 0 to 1)
var velocity = 0

# Flags
var ready = false
var is_grounded = false
var is_picked = false

func _ready():
	
	pass

func _process(delta):
	# TEMP
	if Input.is_action_pressed("ui_accept"):
		#ready = true
		pass
	pass

func _physics_process(delta):
	if ready:
		speed.y += GRAVITY
		var angle = Vector2(-1,0).angle_to_point(speed)
		angle = rad2deg(angle)
		$Sprite.set_rotation_degrees(angle)
		
		move_and_slide(speed, Vector2.UP)
	
	if is_grounded:
		pass
	
	if is_picked:
		pass
	pass

func setup(pos, power):
	player_pos = pos
	
	# Note, power must be a float between 0 and 1
	velocity = MAX_SPEED * power
	
	# MOVE DIR TO SETUP ONCE READY
	dir = (get_global_mouse_position() - player_pos).normalized()
	speed = MAX_SPEED * dir
	ready = true
	pass