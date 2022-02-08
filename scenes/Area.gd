extends Area

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _on_Area_body_entered(body):
	var player = body.get_parent()
	print(player.info["Name"] + " got back to ring")
	#player.in_of_ring()

func _on_Area_body_exited(body):
	var player = body.get_parent()
	print(player.info["Name"] + " is out of ring")
	#player.out_of_ring()
