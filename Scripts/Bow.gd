extends Node

var ArrowScene = preload("res://Scenes/Arrow.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func shoot_arrow(pos, cursor, power):
	var a = ArrowScene.instance()
	a.set_position(pos)
	
	var dir = (cursor - pos).normalized()
	
	a.setup(dir, power)
	#a.translate(Vector2(73, 4))
	var par = get_parent().get_node("Quiver")
	par.add_child(a)
	pass