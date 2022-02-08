extends Node

var player_scene = load("res://entities/Players/Player.tscn")

static func sort_player_by_kills(a : Player, b : Player):
	if a.kills > b.kills:
		return true
	else:
		return false
