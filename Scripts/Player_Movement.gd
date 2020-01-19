extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# export (int) var move_speed = 800
const MAX_MOVE_SPEED = 400
const MAX_FALL_SPEED = 200
const ACCELERATION = 70
const DECELERATION = 70
const GRAVITY = 60
const JUMP_FORCE = 900


var velocity = Vector2()
var accel = 0
var double_jump_flag = false

func get_input():
	var grounded = is_on_floor()
	var walled = is_on_wall()
	var bonked = is_on_ceiling()
	
	# left and right movement
	if Input.is_action_pressed("right"):
		velocity.x += ACCELERATION
	if Input.is_action_pressed("left"):
		velocity.x -= ACCELERATION
	
	# cap horizontal movement
	if velocity.x > MAX_MOVE_SPEED:
		velocity.x = MAX_MOVE_SPEED
	if velocity.x < -MAX_MOVE_SPEED:
		velocity.x = -MAX_MOVE_SPEED
		
	# neither left nor right is being pressed for deceleration
	if not Input.is_action_pressed("right") and not Input.is_action_pressed("left"):
		if velocity.x > 0:
			velocity.x -= DECELERATION
			if velocity.x < 0:
				velocity.x = 0
		if velocity.x < 0:
			velocity.x += DECELERATION
			if velocity.x > 0:
				velocity.x = 0
	
	# reset horizontal movement if touching wall
	if walled:
		velocity.x = 0
	
	# reset double jump when on the ground
	if grounded:
		velocity.y = 0
		double_jump_flag = false
		
	# space pressed to jump
	if not double_jump_flag and Input.is_action_just_pressed('jump'):
		velocity.y = -JUMP_FORCE
		
		# arial jump used, change flag
		if not grounded:
			double_jump_flag = true
	
	# escape pressed to exit
	if Input.is_action_pressed('quit'):
		get_tree().quit()
	
	# gravity is always present (maybe)
	velocity.y += GRAVITY
	
	# you've hit your head!
	if bonked:
		velocity.y = 1

func _physics_process(delta):
	get_input()
  var slide = move_and_slide(velocity, Vector2(0, -1))

func init(nickname, start_position, is_slave):
	#$GUI/Nickname.text = nickname
	global_position = start_position
	if is_slave:
		global_position = start_position + Vector2(400, 0)
		$Sprite.texture = load('res://Images/Shrek.jpg')
