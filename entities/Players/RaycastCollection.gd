extends Spatial

signal is_attackable(being_attacked, attacker)
signal player_out_of_range()

var player

func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var out_of_range_flag = false
	for raycast in self.get_children():
		if raycast.is_colliding():
			if raycast.get_collider().has_method("change_health_by"):
				emit_signal("is_attackable", raycast.get_collider(), player)
				out_of_range_flag = true
				continue
	if out_of_range_flag:
		emit_signal("player_out_of_range")

func _on_Pivot_ready():
	player = get_parent() # Replace with function body.
