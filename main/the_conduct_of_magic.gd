class_name MainGameManager
extends Node

@onready var player_data = PlayerData

@onready var root: MainGameManager = $"."
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
	
	customer_service_shop.customers_booklist = player_data.customers_booklist
	customer_service_shop.commission_booklist = player_data.commission_booklist

func _initialize_main_menu() -> void:
	main_menu.play_game.connect(self._swap_to_shop)
	
func _swap_to_shop() -> void:
	_remove_current_child()
	
	add_child(customer_service_shop)
	customer_service_shop.start_day()
	
func _swap_to_lab() -> void:
	_remove_current_child()
	
	rune_picking_lab.initialize_commission_list(player_data.commission_booklist)
	add_child(rune_picking_lab)

func _remove_current_child() -> void:
	for child in root.get_children():
		remove_child(child)
