class_name CustomerServiceGameManager
extends Node

# This will be replaced with resourcce data for the day. or the modular generation of customers.
@onready var customer: PackedScene = preload("res://Customers/customer.tscn") 

@onready var shop: ShopManager = %Shop
@onready var actions_UI: ActionsUI  = $"Bottom UI/HBoxOfUI/CsActionsChoice"

var current_day: int = 1
var customers_booklist: Dictionary  # The total customer to keep track of between days
var customers_for_the_day: Array[Customer] = []
var current_customer: Variant = null # This would either be a customer object or no one -> null, used to check whether the day can be properly ended as customer at the table should still be addressed.

signal customer_has_been_processed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Read data and Initalize current level
	
	# Connect action button signals
	actions_UI.accepting_request.connect(self.order_accepted)
	actions_UI.rejecting_request.connect(self.order_rejected)
	actions_UI.return_artifact.connect(self.artifact_returned)
	actions_UI.failed_commission.connect(self.commission_failed)
	actions_UI.ending_day.connect(self.end_day)
	
	start_day()

func start_day() -> void:
	actions_UI.end_day_button.disabled = false
	print("The current day is: ", current_day)
	# Reset the customers for the day
	customers_for_the_day = []
	
	# Add in all the customers whose commission makes them come back this day
	if customers_booklist.has(current_day):
		for customer in customers_booklist[current_day]:
			customers_for_the_day.append(customer)
	else:
		print("No customers are pickig up orders today!")
	
	# Generate new customers if needed
	if len(customers_for_the_day) < 3:

		for i in range(5 - len(customers_for_the_day)):
			# Make a customer object
			var customer_instance = create_customer(GameConstants.Locations.ParentsWorkshop)
			
			customers_for_the_day.append(customer_instance)
			
		# TODO: Insert in special customers
			
	# Placiing customers into the shop scene to be managed there on when and where to spawn
	shop.initialize(customers_for_the_day)
	
func create_customer(location) -> Customer:
	# Make a customer object
	var customer_instance = customer.instantiate() as Customer
	customer_instance.send_order.connect(self.process_customer) 
	
	# Make an instance of a customer data resource THIS PART IS ONLY NEEDED FOR NONE SPECIAL NPCs
	var customer_resource: CustomerData = load("res://Customers/customer_data.gd").new()

	customer_instance.fill_in_customer_data(customer_resource, GameConstants.Locations.ParentsWorkshop)
	
	return customer_instance

# Things to do when the customer sends their order
func process_customer(customer: Customer) -> void:
	current_customer = customer
	# Enable UI elements using data in the order
	if !customer.is_returning:
		actions_UI.enable_request_actions()
	elif customer.is_returning:
		actions_UI.enable_submission_actions()
	else:
		push_error("Boolean is_returning has a none truth value!")

func order_accepted() -> void:
	# Save customer to return
	
	current_customer.is_returning = true
	current_customer.return_day = current_day + current_customer.patience
	print("Order has been accepted! Customer returning: ", current_customer.return_day)
	if !customers_booklist.has(current_customer.return_day):
		customers_booklist[current_customer.return_day] = []
	customers_booklist[current_customer.return_day].append(current_customer)
	
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

func artifact_returned() -> void:
	print("Artifact returned!")
	# Make customer leave
	current_customer.leave_store()
	current_customer = null
	
func commission_failed() -> void:
	print("Commission Failed!")
	# Make customer leave
	current_customer.leave_store()
	current_customer = null
	
func end_day() -> void:
	print("Ending the day")
	
	# Make all customers leave except the one you are talking to
	shop.day_ended = true
	for customer in customers_for_the_day.slice(0, shop.customers_spawned):
		if customer != null and customer != current_customer:
			customer.leave_store()
	
	if current_customer != null:
		await customer_has_been_processed
	
	# TODO: Closing sequence
	print("Customer Service has ENDED!")
	current_day += 1
	print(customers_booklist)
	$TransitionToNextDay.start()
	await $TransitionToNextDay.timeout
	start_day()
	
