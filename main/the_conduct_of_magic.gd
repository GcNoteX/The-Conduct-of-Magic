class_name MainGameManager
extends Node

@export var customers_booklist: Dictionary = {} # The total customer to keep track of between days
@export var commission_booklist: Array[CommissionData] = []

@onready var CustomerServiceShop: CustomerServiceGameManager = $CustomerService
@onready var RunePickingLab: RPArtifactManager = $RunePicking

func _ready() -> void:
	remove_child(RunePickingLab)
	
	_initialize_shop_and_lab_scene()

func _initialize_shop_and_lab_scene() -> void:
	CustomerServiceShop.ending_commission_session.connect(self._swap_to_lab)
	RunePickingLab.ending_lab_session.connect(self._swap_to_shop)
	
	CustomerServiceShop.customers_booklist = customers_booklist
	CustomerServiceShop.commission_booklist = commission_booklist
	print("passing...")
	
func _swap_to_shop() -> void:
	print("Swapping to shop")
	remove_child(RunePickingLab)
	add_child(CustomerServiceShop)
	CustomerServiceShop.start_day()
	
func _swap_to_lab() -> void:
	RunePickingLab.initialize_commission_list(commission_booklist)
	remove_child(CustomerServiceShop)
	add_child(RunePickingLab)
