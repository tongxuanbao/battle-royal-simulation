extends Area

signal everybody_exited(body)

var players_in_range = []
var own_body = null

func _ready():
	pass

func _on_ChasingRange_body_entered(body):
	if body != own_body:
		players_in_range.append(body)

func _on_ChasingRange_body_exited(body):
	players_in_range.erase(body)
	if players_in_range.empty():
		emit_signal("everybody_exited", body)

func _on_Pivot_ready():
	own_body = get_parent()
