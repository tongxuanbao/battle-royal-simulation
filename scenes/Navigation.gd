extends Navigation

const NAME_FILE_PATH = "res://assets/waifu_info/listname.txt"
const ANIME_FILE_PATH = "res://assets/waifu_info/listanime.txt"
const IMAGE_PATH = "res://assets/waifu_info/images/"
const MAX_XY = 380

var player_scene = load("res://entities/Players/Player.tscn")
var camera_scene = load("res://entities/ThirdPersonCam/ThirdPersonCam.tscn")

var names = CommonUtils.load_text_file(NAME_FILE_PATH).split("\n")
var animes = CommonUtils.load_text_file(ANIME_FILE_PATH).split("\n")


func _ready():
	GlobalVariables.player_num = 100
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	for i in range(GlobalVariables.player_num):
		# Create Player
		var player = player_scene.instance()
		player.init({	"Name" : names[i], \
						"Anime" : animes[i], \
						"Rank" : i+1, \
						"Img" : IMAGE_PATH + str(i+1) + ".jpg",
						"Kills": 0})
		var spawn_location = self.get_closest_point(CommonUtils.get_random_in_ring(rng))
		player.set_location(spawn_location)
		player.connect("death", get_parent(), "_on_Pivot_death")
		self.add_child(player)
		# Create Camera
		var camera = camera_scene.instance()
		self.add_child(camera)
		# RemoteTransform player to camera
		var remote_transform = RemoteTransform.new()
		remote_transform.update_rotation = false
		remote_transform.remote_path = camera.get_path()
		player.add_child(remote_transform)
		# Add pair player-cam to globalvar
		if (player != null) and (camera != null): 
			GlobalVariables.add_player(player, camera)
