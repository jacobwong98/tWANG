extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
#func _ready():
#	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


export (int) var speed = 200

var velocity = Vector2()

func get_input():
    velocity = Vector2()
    if Input.is_action_pressed('ui_right'):
        velocity.x += 1
    if Input.is_action_pressed('ui_left'):
        velocity.x -= 1
    if Input.is_action_pressed('ui_down'):
        velocity.y += 1
    if Input.is_action_pressed('ui_up'):
        velocity.y -= 1
    velocity = velocity.normalized() * speed

func _physics_process(delta):
    get_input()
    velocity = move_and_slide(velocity)

func init(nickname, start_position, is_slave):
	#$GUI/Nickname.text = nickname
	global_position = start_position
	if is_slave:
		$Sprite.texture = load('res://Images/Shrek.jpg')