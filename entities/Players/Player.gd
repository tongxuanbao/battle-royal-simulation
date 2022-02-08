extends KinematicBody

signal direction_changed(new_direction)

onready var state_machine = $StateMachine

var target_position = Vector3.ZERO setget set_target_position
var target_players = []
var info = {} # Name Anime Rank Img Kills
var camera = null

func _ready():
	$Body/StaticBody.connect("mouse_entered", self, "_on_Pivot_mouse_entered")
	$Body/StaticBody.connect("mouse_exited", self, "_on_Pivot_mouse_exited")
	$Body/StaticBody.connect("input_event", self, "_on_Pivot_input_event")
	# Change info
	$HealthBar.change_info(info)
	# Change image
	$Body.set_img(info["Img"])
	# Setup

func focus_on():
	camera.be_active()

func set_camera(c):
	camera = c

func init(i):
	info = i
	
func set_location(v):
	self.transform.origin = v
	
func set_target_position(position):
	target_position = position

func _on_ChasingRange_body_entered(body):
	target_players.push_back(body)
	state_machine._input("Chase")

func _on_ChasingRange_body_exited(body):
	target_players.erase(body)
	if target_players.size() == 0:
		state_machine._input("Walk")
