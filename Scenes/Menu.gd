extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _on_JoinButton_pressed():
	print("Joining")
	Network.connect_to_server("Shrek")
	_load_game()

func _on_CreateButton_pressed():
	print("Creating")
	Network.create_server("Not Shrek")
	_load_game()

func _load_game():
	get_tree().change_scene("res://Scenes/World.tscn")

func _on_SPButton_pressed():
	Network.create_server("DEAD")
	get_tree().change_scene("res://Scenes/World_SP1.tscn")
	pass # Replace with function body.


func _on_SPButton2_pressed():
	Network.create_server("DEAD2")
	get_tree().change_scene("res://Scenes/World_SP2.tscn")
	pass # Replace with function body.
