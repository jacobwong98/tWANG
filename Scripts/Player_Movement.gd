extends KinematicBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	#connect("arrow_pickup", self, "_on_arrow_pickup")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# export (int) var move_speed = 800
const MOVE_SPEED = 400
const JUMP_FORCE = 900
const GRAVITY = 60
const MAX_FALL_SPEED = 200

var velocity = Vector2()
var accel
var double_jump_flag = false

var shooting = false
var arrow_count = 0

func get_input():
	var grounded = is_on_floor()
	var bonked = is_on_ceiling()
	# reset horizontal velocity
	velocity.x = 0
	
	# left and right movement
	if Input.is_action_pressed("right"):
		velocity.x = MOVE_SPEED
	if Input.is_action_pressed("left"):
		velocity.x = -MOVE_SPEED
	
	# reset double jump when on the ground
	if grounded:
		velocity.y = 0
		double_jump_flag = false
		
	# jump
	if not double_jump_flag and Input.is_action_just_pressed('jump'):
		velocity.y = -JUMP_FORCE
		
		if not grounded:
			double_jump_flag = true
			
	if Input.is_action_pressed('quit'):
		get_tree().quit()
	
	# gravity is always present (maybe)
	velocity.y += GRAVITY
	
	# you've hit your head!
	if bonked:
		velocity.y = 1

func try_shooting():
	if Input.is_action_pressed("shoot"):
		if not shooting and arrow_count < 3:
			shooting = true
			arrow_count += 1
			print("shoot")
			$Bow.shoot_arrow(get_position(), get_global_mouse_position(), 1)
		pass
	else:
		shooting = false
	pass
	#print($Quiver.get_child_count())

func _physics_process(delta):
	get_input()
	try_shooting()
	
	move_and_slide(velocity, Vector2(0, -1))

func _on_arrow_pickup():
	print("ARROW PICKED UP")
	arrow_count -= 1
	if arrow_count < 0:
		arrow_count = 0
	pass