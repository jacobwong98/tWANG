extends Node2D

var shake_amount = 1.0
var shaking = false
var reset_shake = false

func _ready():
	$ShakeCameraTimer.connect("timeout", self, "_on_ShakeCameraTimer_timeout")
	
	get_tree().connect('network_peer_disconnected', self, '_on_player_disconnected')
	get_tree().connect('server_disconnected', self, '_on_server_disconnected')
	
	var new_player = preload('res://Scenes/Player.tscn').instance()
	new_player.name = str(get_tree().get_network_unique_id())
	new_player.set_network_master(get_tree().get_network_unique_id())
	add_child(new_player)
	var info = Network.self_data
	new_player.init(info.name, info.position, false)
	
	new_player.connect("large_fall", self, "_on_large_fall")

func _on_player_disconnected(id):
	get_node(str(id)).queue_free()

func _on_server_disconnected():
	get_tree().change_scene('res://interface/Menu.tscn')

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

func _on_large_fall():
	shaking = true
	$ShakeCameraTimer.start()
	pass

func _on_ShakeCameraTimer_timeout():
	shaking = false