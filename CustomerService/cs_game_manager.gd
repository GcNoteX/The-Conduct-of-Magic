class_name CustomerServiceGameManager
extends Node

# This will be replaced with resourcce data for the day. or the modular generation of customers.
@onready var customer: PackedScene = preload("res://Customers/customer.tscn") 
@onready var shop: ShopManager = %Shop
@onready var actions_UI: ActionsUI  = $"Bottom UI/HBoxOfUI/CsActionsChoice"

var customers: Array[Customer] = []
var current_customer: Variant = null # This would either be a customer object or no one -> null
var day_ended: bool = false

signal customer_has_been_processed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Read data and Initalize current level
	
	# Customer's initialization and pass it to the shop node
	var no_of_customers = randi_range(1, 4)
	print("Generating ", no_of_customers, " customers")
	for i in range(no_of_customers):
		var customer_instance = customer.instantiate() as Customer
		print("Adding ", customer_instance , " to shop")
		customers.append(customer_instance)
				
		customer_instance.send_order.connect(self.process_customer) 
		
	# Placiing customers into the shop scene to be managed there on when and where to spawn
	shop.initialize(customers)
	
	# Connect action button signals
	actions_UI.accepting_request.connect(self.order_accepted)
	actions_UI.rejecting_request.connect(self.order_rejected)
	actions_UI.ending_day.connect(self.end_day)

# Things to do when the customer sends their order
func process_customer(customer: Customer) -> void:
	current_customer = customer
	print("Processing Customer order!")
	# Enable UI elements using data in the order
	actions_UI.enable_actions()


func order_accepted() -> void:
	print("Order has been accepted!")
	# Make customer leave
	current_customer.leave_store()
	current_customer = null
	
	# TODO: Save data
	
	emit_signal("customer_has_been_processed")
	
func order_rejected() -> void:
	print("Order has been rejected")
	# Make customer leave
	current_customer.leave_store()
	current_customer = null
	
	# TODO: Save data
	
	emit_signal("customer_has_been_processed")
	
func end_day() -> void:
	print("Ending the day")
	
	# Make all customers leave except the one you are talking to
	day_ended = true
	shop.day_ended = day_ended
	for customer in customers:
		if customer.initialized and customer != current_customer:
			customer.leave_store()
	
	if current_customer != null:
		await customer_has_been_processed
	
	# TODO: Closing sequence
	print("Customer Service has ENDED!")
