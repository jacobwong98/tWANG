extends Node2D

var shake_amount = 1.0
var shaking = false

var PlayerScene = preload("res://Scenes/Player.tscn")
var player

var totalTargets = 0
var targetsBroken = 0

var level_complete = false
var do_once = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShakeCameraTimer.connect("timeout", self, "_on_ShakeCameraTimer_timeout")
	
	# Pretend we are in an network and set up the player as master
	player = PlayerScene.instance()
	player.init("ttt", Vector2(250, 250), false)
	add_child(player)
	player.connect("large_fall", self, "_on_large_fall")

	# Connect targets to player for processing
	for i in range($Targets.get_child_count()):
		get_node("Targets/Target" + String(i+1)).connect("target_broken", self, "_on_target_broken")
	
	totalTargets = $Targets.get_child_count()
	pass # Replace with function body.

func _process(delta):
	if shaking:
	    $Camera2D.set_offset(Vector2( \
	        512 + rand_range(-1.0, 1.0) * shake_amount, \
	        300 + rand_range(-1.0, 1.0) * shake_amount \
	    ))
	
	if level_complete:
		if not do_once:
			do_once = true
			player.queue_free()
			$HUD/Label.show()
		
		if Input.is_action_pressed("jump"):
			get_tree().change_scene("res://Scenes/Menu.tscn")
		pass

func _on_large_fall():
	shaking = true
	$ShakeCameraTimer.start()
	pass

func _on_ShakeCameraTimer_timeout():
	shaking = false

func _on_target_broken():
	targetsBroken += 1
	
	if targetsBroken == totalTargets:
		level_complete = true
		pass
	pass