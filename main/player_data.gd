extends Node

var player_data: PlayerDataResource

func _ready() -> void:
	initialize_from_save()
	#player_data.display_player_data()

func initialize_from_save():
	# Player data from the save will all be placed in PlayerDataManager.player_data to be used.
	player_data = load("res://main/player_resource.tres")
	#TODO: LOAD Special Characters
	#player_data.fill_in_customer_booklist()
