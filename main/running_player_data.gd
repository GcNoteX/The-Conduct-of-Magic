# This file is to hold the players data during running and carry some
# functionality to merge the data to the json save file

# The game interacts with an instance of this resource
# The save manager will save data through functions and data held within this resource
extends Node

@export var player_name: String
@export var player_sprite: String

@export var coins: int
@export var reputation: int
@export var stamina: float
@export var location: String

@export var game_state: String

@export var customers_booklist: Dictionary = {}
@export var commission_booklist: Array[CommissionData] = []

func _ready() -> void:
	pass

func load_player_data() -> void:
	if SaveManager.check_if_save_exists():
		var player_save = SaveManager.read_save()
		
		player_name = player_save["player_profile"]["player_name"]
		player_sprite = player_save["player_profile"]["player_sprite"]
		coins = int(player_save["player_profile"]["coins"])
		reputation = int(player_save["player_profile"]["reputation"])
		stamina = float(player_save["player_profile"]["stamina"])
		location = player_save["player_profile"]["location"]
		game_state = player_save["player_profile"]["game_state"]
		
		# The reason I do not use the return_day of the customer is because special customers
		# Which have not been seen, do not have a return_day set yet, it would cause errors. 
		for day in player_save["customer_booklist"].keys():
			for customer_data in player_save["customer_booklist"][day]:
				if !customers_booklist.has(day):
					customers_booklist[day] = []
				customers_booklist[day].append(Customer.cast_data_to_customer_instance(customer_data))
		
		for day in customers_booklist.keys():
			for customer in customers_booklist[day]:
				if customer.is_returning:
					commission_booklist.append(customer.commission)
		
		
	else:
		push_error("Attempted to load player data when no such thing exist")
	
func save_player_data() -> void:
	var data = cast_player_data_to_dict()
	SaveManager.save(data)

func cast_player_data_to_dict():
	pass
