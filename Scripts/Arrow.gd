extends KinematicBody2D

var ACScene = preload("res://Scenes/ArrowCollectable.tscn")

const MAX_SPEED = 750
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
var is_stuck = false

# Used to remove arrows from ground
var lift_out = false

func _ready():
	$StuckTimer.connect("timeout", self, "_on_StuckTimer_timeout")
	pass

func _process(delta):
	pass

func _physics_process(delta):
	if ready:
		speed.y += GRAVITY
		var angle = Vector2(-1,0).angle_to_point(speed)
		angle = rad2deg(angle)
		$Sprite.set_rotation_degrees(angle)
		
		move_and_slide(speed, Vector2.UP)
		
		if is_on_floor():
			ready = false
			is_grounded = true
			lift_out = true
			pass
		
		if is_on_ceiling():
			ready = false
			is_grounded = true
			pass
		
		if is_on_wall():
			speed.x = 0
			ready = false
			is_grounded = true
			pass
	
	if is_grounded:
		if not is_stuck:
			is_stuck = true
			$StuckTimer.start()
		pass
	pass

func setup(dir_o, power):	
	# Note, power must be a float between 0 and 1
	velocity = MAX_SPEED * power
	
	dir = dir_o
	# MOVE DIR TO SETUP ONCE READY
	speed = velocity * dir
	ready = true
	pass

func _on_StuckTimer_timeout():
	var a = ACScene.instance()
	a.connect("arrow_pickup", get_parent().get_parent(), "_on_arrow_pickup")
	
	if lift_out:
		a.set_position(get_position() + Vector2(0, -10))
	else:
		a.set_position(get_position())
	
	var par = get_parent().get_parent().get_parent()
	#print(par.name)
	par.add_child(a)
	
	queue_free()
	is_grounded = false
	pass # Replace with function body.