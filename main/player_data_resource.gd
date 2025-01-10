class_name PlayerDataResource
extends Resource

@export var coins: float
@export var stamina: float
@export var customers_booklist: Dictionary = {} # The total customer to keep track of between days
@export var commission_booklist: Array[CommissionData] = []

func fill_in_customer_booklist() -> void:
	#print("Filling booklist")
	var customer: PackedScene = load("res://Customers/customer.tscn")
	# for customer in the save file
	var customer_instance = customer.instantiate() as Customer
	var customer_resource = load("res://Customers/customers_data/Sylas.tres")
	customer_instance.fill_in_customer_data(customer_resource, GameConstants.Locations.ParentsWorkshop)
	customers_booklist[1] = [customer_instance]

func display_player_data() -> void:
	print("Customer Booklist: ")
	print(customers_booklist)
	print("Commission Booklist: ")
	print(commission_booklist)
