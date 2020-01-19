extends Node2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
signal target_broken

# Called when the node enters the scene tree for the first time.
func _ready():
	$Area2D.connect("area_entered", self, "_on_Area2D_area_entered")
	
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Area2D_area_entered(area):
	if area.name == "ArrowHitbox":
		emit_signal("target_broken")
		queue_free()
	pass # Replace with function body.