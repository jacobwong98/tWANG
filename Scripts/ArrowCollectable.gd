extends KinematicBody2D

signal arrow_pickup

const GRAVITY = 10
var vely = 20

var is_picked = false
var offset = 0
var offset_dir = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite.modulate = Color("FF6655")
	$Area2D.connect("area_entered", self, "_on_Area2D_area_entered")
	if is_on_wall() or is_on_floor():
		set_position(get_position()+Vector2(0, -20))

func _physics_process(delta):
	vely += GRAVITY
	move_and_slide(Vector2(0, vely), Vector2.UP)
	
	if is_on_floor():
		vely = 0
		$Sprite.set_position($Sprite.get_position() + Vector2(offset,0))
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
