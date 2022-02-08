extends StaticBody

signal damage_taken(value, dealt_by)

func _ready():
	pass # Replace with function body.

func get_position():
	return get_parent().get_parent().transform.origin

func change_health_by(value, dealt_by : Player):
	emit_signal("damage_taken", value, dealt_by)
