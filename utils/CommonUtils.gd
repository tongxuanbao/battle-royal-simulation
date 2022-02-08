extends Node

func _ready():
	pass

func load_text_file(path):
	var f = File.new()
	var err = f.open(path, File.READ)
	if err != OK:
		printerr("Could not open file, error code ", err)
		return ""
	var text = f.get_as_text()
	f.close()
	return text

func get_random_in_circle(position, radius, rng):
	var r = sqrt(rng.randi_range(0, radius*radius))
	var theta = rng.randf() * 2 * PI
	var x = int(position.x + r * cos(theta))
	var z = int(position.z + r * sin(theta))
	return Vector3(x, position.y, z)

func get_random_in_ring(rng, next_ring = false):
	var radius = clamp(GlobalVariables.ring_rad, 0, 500)
	if next_ring:
		radius = clamp(GlobalVariables.next_rad, 0, 500)
	return get_random_in_circle(Vector3.ZERO, radius, rng)
