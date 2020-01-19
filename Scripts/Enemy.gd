extends KinematicBody2D

signal large_fall
signal arrow_gone
signal injured

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.modulate = Color("FF0000")
	
	$ChargeTimer.connect("timeout", self, "_on_ChargeTimer_timeout")
	$ChargeTimer.start()
	$IdeaTimer.start()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if input_right:
		get_node("Sprite").set_flip_h(true)
		$AnimationPlayer.play("walk")
		
		$FrontCheck.set_rotation_degrees(-90)
		$DoubleJumpCheck.set_rotation_degrees(-180)
	elif input_left:
		get_node("Sprite").set_flip_h(false)
		$AnimationPlayer.play("walk")
		
		$FrontCheck.set_rotation_degrees(90)
		$DoubleJumpCheck.set_rotation_degrees(90)
	else:
		$AnimationPlayer.stop()
		#print("stopping")


# export (int) var move_speed = 800

const MAX_MOVE_SPEED = 250
const MAX_FALL_SPEED = 400
const ACCELERATION = 40
const DECELERATION = 50
const GRAVITY = 40
const JUMP_FORCE = 850

var player_pos = Vector2()

var velocity = Vector2()
var accel = 0
var double_jump_flag = false

var scaler = 0

var start_shoot = false
var shooting = false
var power_level = 0
var arrow_count = 0

var close_call = 0
var idea_choice = 0
var woke = false

var hit_count = 0

# Input emulations
var input_right = false
var input_left = false
var input_up = false
var input_down = false
var input_jump = false
var input_shot = false

func decision_tree():
	input_right = false
	input_left = false
	input_up = false
	input_down = false
	input_jump = false
	input_shot = false
	
	if player_pos.x > get_position().x:
		input_right = true
	elif player_pos.x < get_position().x:
		input_left = true
	if player_pos.y < get_position().y:
		input_up = true
	elif player_pos.y > get_position().y:
		input_down = true
	
	if $FrontCheck.is_colliding():
		input_jump = true
	
	var del = player_pos - get_position()
	del = sqrt((del.x*del.x) + (del.y*del.y))
	#print(del)
	if del < 150 and idea_choice < 3:
		scaler = 0.7
			#close_call = 0
	else:
		scaler = 1
# gets and handles inputs
func get_input():
	# left and right movement
	if input_right:
		velocity.x += ACCELERATION * scaler
	if input_left:
		velocity.x -= ACCELERATION * scaler
	# Up and down movement
	if input_down:
		velocity.y += ACCELERATION * scaler
	if input_up:
		velocity.y -= ACCELERATION * scaler
	
	
	# cap horizontal movement
	if velocity.x > MAX_MOVE_SPEED:
		velocity.x = MAX_MOVE_SPEED
	if velocity.x < -MAX_MOVE_SPEED:
		velocity.x = -MAX_MOVE_SPEED
	
	if velocity.y > MAX_MOVE_SPEED:
		velocity.y = MAX_MOVE_SPEED
	if velocity.y < -MAX_MOVE_SPEED:
		velocity.y = -MAX_MOVE_SPEED
	
	# neither left nor right is being pressed for deceleration
	if not input_right and not input_left:
		if velocity.x > 0:
			velocity.x -= DECELERATION
			if velocity.x < 0:
				velocity.x = 0
		if velocity.x < 0:
			velocity.x += DECELERATION
			if velocity.x > 0:
				velocity.x = 0
	# escape pressed to exit
	
	velocity *= scaler

func _physics_process(delta):
	if woke:
		idea_choice = 0
	
	if idea_choice > 1 and hit_count < 2:
		player_pos = get_parent().get_node("player").get_position()
	
	var arrows = get_parent().get_node("CollectableArrows").get_child_count()
	if arrows > 0:
		player_pos = get_parent().get_node("CollectableArrows").get_child(0).get_position()
		woke = true
	else:
		woke = false
		
	decision_tree()
	get_input()
	move_and_slide(velocity, Vector2(0, -1))

func _on_arrow_pickup():
	#print("ARROW PICKED UP")
	arrow_count -= 1
	if arrow_count < 0:
		arrow_count = 0
	$yoink.play()

func init(nickname, start_position, is_slave):
	#$GUI/Nickname.text = nickname
	global_position = start_position
	if is_slave:
		global_position = start_position + Vector2(600, 200)
		$Sprite.texture = load('res://Images/Shrek.jpg')

func _on_ChargeTimer_timeout():
	$whoosh.play()
	pass

func _on_IdeaTimer_timeout():
	idea_choice = randi()%3 + 1
	#print(idea_choice)
	pass # Replace with function body.

func _on_Area2DEnemy_area_entered(area):
	if area.name == "CollectableArea2D":
		emit_signal("arrow_gone")
	elif area.name == "ArrowHitbox":
		hit_count += 1
		if hit_count >= 2:
			emit_signal("injured")
	pass # Replace with function body.
