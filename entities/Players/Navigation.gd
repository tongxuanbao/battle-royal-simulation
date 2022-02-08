extends Spatial

signal destination_reached
signal node_changed

onready var navigation = $"/root/Main/Navigation"

var path = []
var path_node = 0

func get_current_node():
	return path[path_node]

func get_new_path(host, target_position):
	path = navigation.get_simple_path(host.translation, \
								navigation.get_closest_point(target_position), false)
	if path.size() > 0:	
		path_node = 0
		emit_signal("node_changed")
		return true
	else:
		return false
		
func get_destination():
	if path.size() > 0:
		return path[path.size()-1]

func get_closest_point(position):
	return navigation.get_closest_point(position)
	
func _process(_delta):
	if get_parent().distance_to_target() < .1:
		path_node += 1
		if path_node < path.size():
			emit_signal("node_changed")
		else:
			emit_signal("destination_reached")
