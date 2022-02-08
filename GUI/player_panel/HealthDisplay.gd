extends Sprite3D

onready var bar = $Viewport/Panel/CenterContainer/VBoxContainer/HealthBar2D
onready var nam = $Viewport/Panel/CenterContainer/VBoxContainer/Name
onready var anime = $Viewport/Panel/CenterContainer/VBoxContainer/Anime
onready var kills = $Viewport/Panel/CenterContainer/VBoxContainer/Kills
onready var cooldown_healing = $Health/CooldownHealing

func _ready():
	texture = $Viewport.get_texture()

func set_max_value(value):
	bar.max_value = value

func update(value, full):
	bar.update_healthbar(value, full)
	
func change_info(info):
	nam.text = info["Name"] + " [#" + str(info["Rank"]) + "]"
	anime.text = str(info["Anime"])
	self.update_kills(info["Kills"])

func update_kills(k):
	kills.text = "Kills: " + str(k)

func reset_timer():
	cooldown_healing.wait_time = 7.0
	cooldown_healing.start()
