extends TextureProgress

var bar_red = preload("res://assets/health_bar/barHorizontal_red.png")
var bar_green = preload("res://assets/health_bar/barHorizontal_green.png")
var bar_yellow = preload("res://assets/health_bar/barHorizontal_yellow.png")

func _ready():
	texture_progress = bar_green
	value = max_value

func update_healthbar(amount, full):
	texture_progress = bar_green
	if amount < full * 0.7:
		texture_progress = bar_yellow
	if amount < full * 0.35:
		texture_progress = bar_red
	value = amount
