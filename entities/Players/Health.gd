extends Spatial

signal heal

var cooldown_healing

func _ready():
	cooldown_healing = $CooldownHealing

func _on_CooldownHealing_timeout():
	if cooldown_healing.wait_time == 7.0:
		cooldown_healing.wait_time = 1.0
	else:
		emit_signal("heal")
	cooldown_healing.start()
