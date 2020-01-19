extends Node2D

var shake_amount = 1.0
var shaking = false
var reset_shake = false

var PlayerScene = preload("res://Scenes/Player.tscn")
var player

var EnemyScene = preload("res://Scenes/Enemy.tscn")
var enemy

var level_complete = false
var level_failed = false
var do_once = false

var arrows_gone = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$ShakeCameraTimer.connect("timeout", self, "_on_ShakeCameraTimer_timeout")
	
	
	
	# Pretend we are in an network and set up the player as master
	player = PlayerScene.instance()
	player.init("ttt", Vector2(250, 250), false)
	player.name = "player"
	add_child(player)
	player.connect("large_fall", self, "_on_large_fall")
	player.connect("player_injured", self, "_on_player_injured")
	
	enemy = EnemyScene.instance()
	enemy.init("eee", Vector2(900, 400), false)
	enemy.name = "enemy"
	add_child(enemy)
	enemy.connect("arrow_gone", self, "_on_arrow_gone")
	enemy.connect("injured", self, "_on_injured")
	
	pass # Replace with function body.

func _process(delta):
	if shaking:
		reset_shake = false
		$Camera2D.set_offset(Vector2( \
	        512 + rand_range(-1.0, 1.0) * shake_amount, \
	        300 + rand_range(-1.0, 1.0) * shake_amount \
	    ))
	else:
		if not reset_shake:
			reset_shake = true
			$Camera2D.set_offset(Vector2(512, 300))
	
	if level_complete:
		if not do_once:
			do_once = true
			player.queue_free()
			enemy.queue_free()
			$HUD/Label.show()
		
		if Input.is_action_pressed("OK"):
			get_tree().change_scene("res://Scenes/Menu.tscn")
		pass
	elif level_failed:
		if not do_once:
			do_once = true
			player.queue_free()
			enemy.queue_free()
			$HUD/Label.text = "MISSION FAILED \n PRESS Q TO CONTINUE"
			$HUD/Label.show()
			pass
		
		if Input.is_action_pressed("OK"):
			get_tree().change_scene("res://Scenes/Menu.tscn")
		pass

func _on_large_fall():
	shaking = true
	$ShakeCameraTimer.start()
	pass

func _on_ShakeCameraTimer_timeout():
	shaking = false
	
func _on_arrow_gone():
	arrows_gone += 1
	if arrows_gone >= 3:
		level_failed = true

func _on_injured():
	level_complete = true
	
func _on_player_injured():
	level_failed = true
	pass