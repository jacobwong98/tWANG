extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# export (int) var move_speed = 800
const MOVE_SPEED = 500
const JUMP_FORCE = 2500
const GRAVITY = 70
const MAX_FALL_SPEED = 1000

var velocity = Vector2()
var double_jump_flag = false
func get_input():
	var grounded = is_on_floor()
	var bonked = is_on_ceiling()
	# reset horizontal velocity
	velocity.x = 0
	
	# left and right movement
	if Input.is_action_pressed("right"):
		velocity.x += MOVE_SPEED
	if Input.is_action_pressed("left"):
		velocity.x -= MOVE_SPEED
	
	# jump
	if not double_jump_flag and Input.is_action_just_pressed('jump'):
		velocity.y = -JUMP_FORCE
		
		if not grounded:
			double_jump_flag = true
	if Input.is_action_pressed('quit'):
		get_tree().quit()

	velocity.y += GRAVITY
	# you've hit your head!
	if bonked:
		velocity.y = 1
		
	# reset double jump when on the ground
	if grounded:
			double_jump_flag = false

func _physics_process(delta):
	get_input()

	move_and_slide(velocity, Vector2(0, -1))
