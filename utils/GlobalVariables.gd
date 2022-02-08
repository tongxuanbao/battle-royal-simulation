extends Node

var players = []
var player_num = 0
var ring_rad = 500
var next_rad = 500
var ring_time_left = 0
	
class MyCustomSorter:
	static func sort_descending(a, b):
		var player1 = a[0]
		var player2 = b[0]
		if !is_instance_valid(player1):
			return false
		elif !is_instance_valid(player2):
			return true
		elif player1.info["Kills"] > player2.info["Kills"]:
			return true
		return false

func is_in_ring(v):
	var center = Vector3.ZERO
	center.y = v.y
	if center.distance_to(v) > (ring_rad):
		return false
	else:
		return true
		
func is_in_next_ring(v):
	var center = Vector3.ZERO
	center.y = v.y
	if center.distance_to(v) > next_rad:
		return false
	else:
		return true

func add_player(player : Player, cam : Spatial):
	players.append([player, cam])

func sort_player():
	for player in players:
		if not is_instance_valid(player[0]) or not is_instance_valid(player[1]):
			players.erase(player)
	players.sort_custom(MyCustomSorter, "sort_descending")
	
func print_player():
	for i in range(5):
		print(players[i][0].nam + " killed " + str(players[i][0].kills))
