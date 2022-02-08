extends PanelContainer


var con_lai = PoolByteArray([0x43, 0xc3, 0xb2, 0x6e, 0x20, \
				0x53, 0xe1, 0xbb, 0x91, 0x6e, 0x67, 0x3a, 0x20]).get_string_from_utf8()
# Called when the node enters the scene tree for the first time.
func _ready():
	$CenterContainer/HBoxContainer/Label.text = con_lai + str(GlobalVariables.players.size())
	$CenterContainer/HBoxContainer/Label2.text = \
	" | Bo: " + str(int(GlobalVariables.ring_time_left))

func update():
	$CenterContainer/HBoxContainer/Label.text = con_lai + str(GlobalVariables.players.size())

func _process(_delta):
	$CenterContainer/HBoxContainer/Label2.text = \
	" | Bo: " + str(int(GlobalVariables.ring_time_left))
