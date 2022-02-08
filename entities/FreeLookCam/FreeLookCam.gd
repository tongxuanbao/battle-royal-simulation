extends KinematicBody

onready var camera = $InnerPivot/Camera

export var rotation_speed = PI / 2
export var max_zoom = 3.0
export var min_zoom = 0.5
export var zoom_speed = 0.15
export var mouse_control = true
export var mouse_sensitive = 0.005
export var invert_x = false
export var invert_y = false
export var first_person = false

var max_speed = 100
var velocity = Vector3()
var zoom = 1.5

func get_moving_dir():
	var input_dir = Vector3()
	if Input.is_action_pressed("ui_w"):
		input_dir -= camera.global_transform.basis.z
	if Input.is_action_pressed("ui_s"):
		input_dir += camera.global_transform.basis.z
	if Input.is_action_pressed("ui_a"):
		input_dir -= camera.global_transform.basis.x
	if Input.is_action_pressed("ui_d"):
		input_dir += camera.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir
	
func get_input():
	# Up & Down moving
	if Input.is_action_pressed("ui_space"):
		var _velocity = move_and_slide(Vector3.UP * max_speed, Vector3.UP, true)
	if Input.is_action_pressed("ui_ctrl"):
		var _velocity = move_and_slide(Vector3.DOWN * max_speed, Vector3.UP, true)

func _physics_process(_delta):
	get_input()
	var desired_velocity = get_moving_dir() * max_speed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity = move_and_slide(velocity, Vector3.UP, true)

func _unhandled_input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if mouse_control and event is InputEventMouseMotion:
			if event.relative.x != 0:
				var dir = 1 if invert_x else -1
				rotate(Vector3.UP, dir * event.relative.x * mouse_sensitive)
			if event.relative.y != 0:
				var dir = 1 if invert_y else -1
				$InnerPivot.rotate(Vector3.RIGHT, dir * event.relative.y * mouse_sensitive)

func focus_on():
	var p = get_viewport().get_camera().get_parent().get_parent()
	if (p is ThirdCamera) and is_instance_valid(p.player):
		self.transform.origin = p.player.transform.origin + Vector3(0, 3, 0)
	camera.make_current()
