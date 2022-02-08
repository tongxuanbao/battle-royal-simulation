extends Panel


var MouseOver = false

func _ready():
	var _error = self.connect('gui_input', get_node("/root/Main/GUI/Leaderboard"), "_gui_input")
	for child in self.get_children():
		_error = child.connect('gui_input', get_node("/root/Main/GUI/Leaderboard"), "_gui_input")

func _on_ScoreItem_mouse_entered():
	MouseOver = true

func _on_ScoreItem_mouse_exited():
	MouseOver = false
