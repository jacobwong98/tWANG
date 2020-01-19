extends KinematicBody2D

signal large_fall
signal player_injured

# Called when the node enters the scene tree for the first time.
func _ready():
	$ArrowCooldown.connect("timeout", self, "_on_ArrowCooldown_timeout")
	$ChargeTimer.connect("timeout", self, "_on_ChargeTimer_timeout")
	$Area2D.connect("area_entered", self, "_on_Area2D_area_entered")
	pass # Replace with function body.

# export (int) var move_speed = 800

const MAX_MOVE_SPEED = 250
const MAX_FALL_SPEED = 400
const ACCELERATION = 40
const DECELERATION = 50
const GRAVITY = 40
const JUMP_FORCE = 650

slave var slave_position = Vector2()

var velocity = Vector2()
var accel = 0
var double_jump_flag = false

var start_shoot = false
var shooting = false
var power_level = 0
var arrow_count = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("right"):
		get_node("Sprite").set_flip_h(true)
		$AnimationPlayer.play("walk")
	elif Input.is_action_pressed("left"):
		get_node("Sprite").set_flip_h(false)
		$AnimationPlayer.play("walk")
	else:
		$AnimationPlayer.stop()
		#print("stopping")
	
	match (3-arrow_count):
		0:
			$Label.text = "0"
			pass
		1:
			$Label.text = "I"
			pass
		2:
			$Label.text = "II"
			pass
		3:
			$Label.text = "III"
			pass

# gets and handles inputs
func get_input():
	# check collisions
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
		# when you land on the ground, you might of been going fast.
		# shake the camera a bit if you hit the ground hard.
		if velocity.y > 1100:
			emit_signal("large_fall")
		
		velocity.y = 0
		double_jump_flag = false
		
	# space pressed to jump
	if not double_jump_flag and Input.is_action_just_pressed('jump'):
		velocity.y = -JUMP_FORCE
		$whoosh.play(0)
		
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

func moveChar(velocity):
	if is_network_master():
		rset_unreliable('slave_position', position)
		move_and_slide(velocity, Vector2(0, -1))
	else:
		move_and_slide(velocity, Vector2(0, -1))
		position = slave_position
	if get_tree().is_network_server():
		var id = int(name)
		if id == 0:
			id += 1 
		Network.update_position(id, position)

# shoot an arrow
func try_shooting():
	if Input.is_action_pressed("shoot") and arrow_count < 3:	
		if not $ArrowChargePivot/ArrowCharge.visible:
			$ArrowChargePivot/ArrowCharge.show()
			$ChargeTimer.start()
			start_shoot = true
		
		# Get local mouse pos then set arrowcharge angle to it
		var mouse_pos = get_local_mouse_position()
		$ArrowChargePivot.rotation = mouse_pos.angle() + PI/2
		$ArrowChargePivot/ArrowCharge.set_scale(Vector2(0.12*power_level/4,0.12*power_level/4))
	
	else:
		if not shooting and start_shoot and arrow_count < 3:
			start_shoot = false
			shooting = true
			arrow_count += 1
			
			$Bow.shoot_arrow(get_position(), get_global_mouse_position(), power_level/4.0)
			$ArrowCooldown.start()
			$twang.play(0)
		else:
			# Have to do this because start_shoot doesnt reset any other way
			start_shoot = false
			pass
		$ArrowChargePivot/ArrowCharge.hide()
		power_level = 1
		$ChargeTimer.stop()
		pass

func _physics_process(delta):
	get_input()
	try_shooting()
	#move_and_slide(velocity, Vector2(0, -1))
	#var slide = move_and_slide(velocity, Vector2(0, -1))
	moveChar(velocity)

func _on_arrow_pickup():
	#print("ARROW PICKED UP")
	arrow_count -= 1
	if arrow_count < 0:
		arrow_count = 0
	$yoink.play(0)


func init(nickname, start_position, is_slave):
	#$GUI/Nickname.text = nickname
	global_position = start_position
	if is_slave:
		global_position = start_position + Vector2(600, 200)
		$Sprite.texture = load('res://Images/Shrek.jpg')

func _on_ChargeTimer_timeout():
	$ChargeTimer.start()
	power_level += 1
	if power_level > 4:
		power_level = 4
	pass

func _on_ArrowCooldown_timeout():
	shooting = false
	pass

func _on_Area2D_area_entered(area):
	if area.name == "Area2DEnemy":
		emit_signal("player_injured")
	pass