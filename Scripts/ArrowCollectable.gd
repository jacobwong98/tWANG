extends Node2D

signal arrow_pickup

var is_picked = false
var offset = 0
var offset_dir = 1

var ground_pos = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.modulate = Color("FF6655")
	$Area2D.connect("area_entered", self, "_on_Area2D_area_entered")
	ground_pos = get_position() + Vector2(0, -15)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _physics_process(delta):
	set_position(ground_pos + Vector2(0, offset))
	#print(offset)
	if offset_dir == 1:
		offset += 0.1
	elif offset_dir == -1:
		offset -= 0.1
	if offset >= 1 or offset <= -1:
		offset_dir *= -1
	
	pass

func _on_Area2D_area_entered(area):
	
	emit_signal("arrow_pickup")
	queue_free()
	pass # Replace with function body.
