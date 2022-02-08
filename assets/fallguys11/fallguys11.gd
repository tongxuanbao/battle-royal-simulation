extends Spatial

signal animation_finished(anim_name)

onready var body = $PB_UI_Character/SKELETON/Root/Skeleton/Body
onready var face = $PB_UI_Character/SKELETON/Root/Skeleton/Face
onready var animation  = $AnimationPlayer

var img = "res://assets/waifu_info/images/1.jpg"
var color = ""
var ani = false

func set_img(i):
	img = i
	var mat = SpatialMaterial.new()
	var image1 = load(img)
	mat.albedo_texture = image1
	face.set_surface_material(0, mat)

func set_random_color():
	var mat = SpatialMaterial.new()
	mat.albedo_color = Color(randf(), randf(), randf())
	mat.metallic = 1
	mat.roughness = 0.9
	body.set_surface_material(0, mat)

func _ready():
	set_random_color()
	animation.play("Walk")

func punch():
	animation.set_current_animation("Honk")
	
func play(a):
	animation.play(a)
	
func stop():
	animation.stop()
	
func queue(a):
	animation.queue(a)
	
func get_queue():
	return animation.get_queue()

func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("animation_finished", anim_name)
