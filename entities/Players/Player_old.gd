extends KinematicBody
class_name Player

enum Dir {UP, DOWN, LEFT, RIGHT}

# Navigation declaration
onready var nav = $Navigation
onready var state = $States
onready var ring_timer = $RingTimer

const gravity = -30
const MAX_WALKING_SPEED = 5
const MAX_RUNNING_SPEED = 8
const MAX_ATTACK_SPEED = 2
const MAX_HEALTH = 50
const rot_speed = 10

signal death(player, killed_by)

var target_position = Vector3.ZERO
var velocity = Vector3.ZERO
var health = 50
var attack_damage = -5
var info = {} # Name Anime Rank Img Kills
var cam = null
var MouseOver = false
var max_speed = 5
var is_out = false

var rng = RandomNumberGenerator.new()

func init(i):
	health = MAX_HEALTH
	info = i
	
func set_camera(c):
	cam = c

func set_location(v3):
	self.transform.origin = v3
	
func process_dying(dealt_by : Player):
	if health <= 0:
		emit_signal("death", self, dealt_by)
	else:
		$HealthBar.reset_timer()
	
func change_health_by(value, dealt_by : Player):
	health += value
	$HealthBar.update(health, MAX_HEALTH)
	if value < 0:
		process_dying(dealt_by)

func random_target_location(next_ring = false):
	var valid = false
	while not valid:
		var location = CommonUtils.get_random_in_ring(rng, next_ring)
		valid = nav.get_new_path(self, location)

func get_destination():
	return nav.get_destination()

func _ready():
	rng.seed = info["Name"].hash()
	$HealthBar.set_max_value(MAX_HEALTH)
	# Change image
	$Body.set_img(info["Img"])
	# Setup
	var damage_adjust = [-2.0, -1.5, -1.0, -0.5, 0, 0, 0.5, 1.0, 1.5, 2]
	self.attack_damage += damage_adjust[int(info["Rank"] / 11)]
	info["Test"] = attack_damage
	$HealthBar.change_info(info)
	random_target_location()

func out_of_ring():
	state.state_to_run()
	
func in_of_ring():
	state.state_to_walk()

func _physics_process(delta):
	#var new_transform = self.transform.looking_at(target_position, Vector3.UP)
	#self.transform = self.transform.interpolate_with(new_transform, rot_speed)
	if GlobalVariables.is_in_ring(self.transform.origin):
		is_out = false
	else:
		is_out = true
		
	
	var direction = target_position-global_transform.origin
	var direction_norm = direction.normalized()
	
	self.rotation.y = lerp(self.rotation.y, atan2(-direction_norm.x, -direction_norm.z),\
														delta * rot_speed)
		
	var _velocity = self.move_and_slide(direction_norm * max_speed, Vector3.UP)

func _on_Navigation_node_changed():
	self.target_position = nav.get_current_node()

func _on_Navigation_destination_reached():
	random_target_location()

func get_position():
	return self.transform.origin

func focus_on():
	cam.be_active()
	
func distance_to_target():
	return self.transform.origin.distance_to(target_position)

func _on_Timer_timeout():
	if is_out:
		_on_StaticBody_damage_taken(-1, self)
		if state.state_ != state.State.RUN:
			state.run()
	else:
		if state.state_ == state.State.RUN:
			state.walk()

func _on_Pivot_mouse_entered():
	MouseOver = true # Replace with function body.

func _on_Pivot_mouse_exited():
	MouseOver = false # Replace with function body.

func _on_Pivot_input_event(_camera, event, _click_position, _click_normal, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and MouseOver and event.pressed:
			self.focus_on()

func _on_StaticBody_damage_taken(value, dealt_by):
	health += value
	$HealthBar.update(health, MAX_HEALTH)
	if value < 0:
		process_dying(dealt_by)

func _on_States_state_changed(state_):
	if state_ == "Walk":
		nav.set_process(true)
		max_speed = MAX_WALKING_SPEED
	elif state_ == "Chase":
		nav.set_process(false)
		max_speed = MAX_RUNNING_SPEED
	elif state_ == "Attack":
		nav.set_process(true)
		max_speed = MAX_ATTACK_SPEED
	elif state_ == "Run":
		nav.set_process(true)
		max_speed = MAX_RUNNING_SPEED

func _on_Health_heal():
	health = clamp(health+1.0, 0, 50.0)
	$HealthBar.update(health, MAX_HEALTH)
