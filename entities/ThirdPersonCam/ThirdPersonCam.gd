extends Spatial
class_name ThirdCamera

onready var camera = $InnerGimbal/Camera
onready var InnerGimbal = $InnerGimbal

export var rotation_speed = PI / 2
export var max_zoom = 10.0	
export var min_zoom = 0.5
export var zoom_speed = 0.5
export var mouse_control = true
export var mouse_sensitive = 0.01
export var invert_x = false
export var invert_y = false
export var first_person = false

var max_speed = 8
var velocity = Vector3()
var zoom = 1.5
var player = null

func be_active():
	camera.make_current()
	
func is_current():
	return camera.current

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

func _process(_delta):
	scale = lerp(scale, Vector3.ONE * zoom, zoom_speed)

func _unhandled_input(event):
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if mouse_control and event is InputEventMouseMotion:
			if event.relative.x != 0:
				var dir = 1 if invert_x else -1
				rotate(Vector3.UP, dir * event.relative.x * mouse_sensitive)
			if event.relative.y != 0:
				var dir = 1 if invert_y else -1
				InnerGimbal.rotate(Vector3.RIGHT, dir * event.relative.y * mouse_sensitive)
		if event.is_action_pressed("ui_scrollup"):
			zoom -= zoom_speed
		if event.is_action_pressed("ui_scrolldown"):
			zoom += zoom_speed
		zoom = clamp(zoom, min_zoom, max_zoom)
