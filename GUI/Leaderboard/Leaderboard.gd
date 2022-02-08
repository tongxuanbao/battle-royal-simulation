tool
extends Panel

const LeaderboardItem = preload("LeaderboardItem.tscn")
const MAX_ITEM = 7

var list_index = 0

func _ready():
	render_board()

func render_board():
	clear_board()
	for i in range(min(GlobalVariables.players.size(), MAX_ITEM)):
		var player = GlobalVariables.players[i][0]
		self.add_item(player.info["Name"], player.info["Rank"], player.info["Kills"])

func add_item(nam, rank, kills):
	var item = LeaderboardItem.instance()
	list_index += 1
	item.get_node("PlayerName").text = nam
	item.get_node("Score").text = str(kills) 
	item.get_node("Rank").text = "[#" + str(rank) + "]" 
	item.margin_top = list_index * 25
	$"Board/HighScores/ItemContainer".add_child(item)

func clear_board():
	var item_container = $"Board/HighScores/ItemContainer"
	if item_container.get_child_count() > 0:
		var children = item_container.get_children()
		for c in children:
			item_container.remove_child(c)
			c.queue_free()

func player_died(_player, _killed_by):
	render_board()

func _gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var item_container = $"Board/HighScores/ItemContainer"
			var i = 0
			for child in item_container.get_children():	
				if child.MouseOver:
					if i < GlobalVariables.players.size():
						GlobalVariables.players[i][0].focus_on()
				i += 1
			if i >= GlobalVariables.players.size():
				render_board()
