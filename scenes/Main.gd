extends Node

const NAME_FILE_PATH = "res://assets/waifu_info/listname.txt"
const ANIME_FILE_PATH = "res://assets/waifu_info/listanime.txt"
const IMAGE_PATH = "res://assets/waifu_info/images/"

onready var nav = $Navigation

var rng = RandomNumberGenerator.new()

var names = CommonUtils.load_text_file(NAME_FILE_PATH).split("\n")
var animes = CommonUtils.load_text_file(ANIME_FILE_PATH).split("\n")

func _enter_tree():
	pass

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	for pair in GlobalVariables.players:
		pair[0].set_camera(pair[1])
		pair[1].player = pair[0]
	$GUI/Leaderboard.render_board()
	$GUI/TotalAlive.update()

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("ui_m"):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if event.is_action_pressed("ui_q"):
		$FreeLookCam.focus_on()

func bold(t):
	return "[b]" + t + "[/b]"

func _on_Pivot_death(player, killed_by):
	killed_by.info["Kills"] += 1
	killed_by.get_node("HealthBar").update_kills(killed_by.info["Kills"])
	if player.cam.is_current():
		$FreeLookCam.focus_on()
	GlobalVariables.players.erase([player, player.cam])
	player.cam.queue_free()
	player.queue_free()
	GlobalVariables.sort_player()
	
	var da_giet = PoolByteArray([0x20, 0xc4, 0x91, 0xc3, 0xa3, 0x20, \
					0x67, 0x69, 0xe1, 0xba, 0xbf, 0x74, 0x20]).get_string_from_utf8()
	var va_co = PoolByteArray([0x2c, 0x20, 0x76, 0xc3, 0xa0, 0x20, 0x63, 0xc3,\
									0xb3, 0x20]).get_string_from_utf8()
	var announcement = bold(killed_by.info["Name"]) + da_giet + bold(player.info["Name"]) + \
								va_co + bold(str(killed_by.info["Kills"])) + " kills.\n"
	$GUI/KillStatus.add_text(announcement)
	$GUI/Leaderboard.player_died(player, killed_by)
	$GUI/TotalAlive.update()
