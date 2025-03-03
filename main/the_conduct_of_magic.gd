class_name MainGameManager
extends Node

@onready var customer_service_shop: CustomerServiceGameManager = $CustomerService
@onready var rune_picking_lab: RPArtifactManager = $RunePicking
@onready var main_menu: MainMenu = $MainMenu

func _ready() -> void:
	remove_child(customer_service_shop)
	remove_child(rune_picking_lab)
	
	_initialize_main_menu()
	_initialize_shop_and_lab_scene()

func _initialize_shop_and_lab_scene() -> void:
	customer_service_shop.ending_commission_session.connect(self._swap_to_lab)
	rune_picking_lab.ending_lab_session.connect(self._swap_to_shop)
	
	customer_service_shop.customers_booklist = PlayerData.customers_booklist
	customer_service_shop.commission_booklist = PlayerData.commission_booklist

func _initialize_main_menu() -> void:
	main_menu.play_game.connect(self.load_game)
	main_menu.instantiate_new_game.connect(self._reinstantiate_booklist)
	
func _swap_to_shop() -> void:
	PlayerData.game_state = "workshop"
	PlayerData.save_player_data()
	
	_remove_current_child()
	
	add_child(customer_service_shop)
	customer_service_shop.start_day()
	
func _swap_to_lab() -> void:
	PlayerData.game_state = "lab"
	PlayerData.save_player_data()
	
	_remove_current_child()
	
	rune_picking_lab.initialize_commission_list(PlayerData.commission_booklist)
	add_child(rune_picking_lab)

func load_game() -> void:
	if PlayerData.game_state == "workshop":
		_swap_to_shop()
	elif PlayerData.game_state == "lab":
		_swap_to_lab()
	else:
		push_error("Loading into invalid game state: ", PlayerData.game_state)

func _remove_current_child() -> void:
	for child in self.get_children():
		remove_child(child)

func _reinstantiate_booklist() -> void:
	print("Reinstantiating boolist")
	customer_service_shop.customers_booklist = PlayerData.customers_booklist
	customer_service_shop.commission_booklist = PlayerData.commission_booklist
