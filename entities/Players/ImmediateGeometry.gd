extends ImmediateGeometry


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var m = SpatialMaterial.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	m.flags_unshaded = true
	m.flags_use_point_size = true
	m.albedo_color = Color.red

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta):
	var player = get_parent()
	self.set_material_override(m)
	self.clear()
	#self.begin(Mesh.PRIMITIVE_POINTS, null)
	#self.add_vertex(path_array[0])
	#self.add_vertex(path_array[path_array.size() - 1])
	#self.end()
	self.begin(Mesh.PRIMITIVE_LINE_STRIP, null)
	self.add_vertex(player.translation)
	self.add_vertex(player.target_position)
	self.end()
