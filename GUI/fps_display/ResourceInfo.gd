extends MarginContainer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _physics_process(_delta):
	$HBoxContainer/VBoxContainer/Stat01.text = "FPS: " + str(Performance.get_monitor(Performance.TIME_FPS))
	$HBoxContainer/VBoxContainer/Stat02.text = "Memory: : " + str(round(Performance.get_monitor(Performance.MEMORY_STATIC)/(1024*1024))) + "MB"

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
