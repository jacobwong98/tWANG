extends Node2D

var shake_amount = 1.0
var shaking = false

var PlayerScene = preload("res://Scenes/Player.tscn")
var player

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShakeCameraTimer.connect("timeout", self, "_on_ShakeCameraTimer_timeout")
	
	# Pretend we are in an network and set up the player as master
	player = PlayerScene.instance()
	player.init("ttt", Vector2(360, 180), false)
	add_child(player)
	player.connect("large_fall", self, "_on_large_fall")

	pass # Replace with function body.

func _process(delta):
	print(player.get_position())
	if shaking:
	    $Camera2D.set_offset(Vector2( \
	        512 + rand_range(-1.0, 1.0) * shake_amount, \
	        300 + rand_range(-1.0, 1.0) * shake_amount \
	    ))

func _on_large_fall():
	shaking = true
	$ShakeCameraTimer.start()
	pass

func _on_ShakeCameraTimer_timeout():
	shaking = false
