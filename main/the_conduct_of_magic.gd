class_name MainGameManager
extends Node

@export var customers_booklist: Dictionary = {} # The total customer to keep track of between days
@export var commission_booklist: Array[CommissionData] = []

@onready var CustomerServiceShop: CustomerServiceGameManager = $CustomerService
@onready var RunePickingLab: RPArtifactManager = $RunePicking

func _ready() -> void:
	_initialize_shop_and_lab_scene()
	
	remove_child(RunePickingLab)
	

func _initialize_shop_and_lab_scene() -> void:
	CustomerServiceShop.ending_commission_session.connect(self._swap_to_lab)
	RunePickingLab.ending_lab_session.connect(self._swap_to_shop)
	
	CustomerServiceShop.customers_booklist = customers_booklist
	CustomerServiceShop.commission_booklist = commission_booklist
	RunePickingLab.initialize_commission_list(commission_booklist)
	
func _swap_to_shop() -> void:
	print("Swaapping to shop")
	remove_child(RunePickingLab)
	add_child(CustomerServiceShop)
	CustomerServiceShop.start_day()
	
func _swap_to_lab() -> void:
	print("Swapping to lab, Commission List: " , commission_booklist , " VS ", RunePickingLab.commission_list, " VS ", RunePickingLab.combox2.commission_list)
	remove_child(CustomerServiceShop)
	add_child(RunePickingLab)
