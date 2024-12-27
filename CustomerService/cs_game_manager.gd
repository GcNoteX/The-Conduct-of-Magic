class_name CustomerServiceGameManager
extends Node


@export var customers_booklist: Dictionary = {}  # The total customer to keep track of between days
@export var commission_booklist: Array[CommissionData] = []
@export var current_day: int = 1

# This will be replaced with resourcce data for the day. or the modular generation of customers.
@onready var player_points: int = PlayerData.player_data.coins
@onready var customer: PackedScene = preload("res://Customers/customer.tscn") 

@onready var shop: ShopManager = %Shop
@onready var customer_display_UI: CustomerDisplay = $"Bottom UI/HBoxOfUI/CsCustomerDisplay"
@onready var commission_dispay_UI: CommissionDisplay = $"Bottom UI/HBoxOfUI/CsCommissionDisplay"
@onready var actions_UI: ActionsUI  = $"Bottom UI/HBoxOfUI/CsActionsChoice"
@onready var points_UI: RichTextLabel = $Control/PanelContainer/RichTextLabel

var customers_for_the_day: Array[Customer] = []
var current_customer: Variant = null # This would either be a customer object or no one -> null, used to check whether the day can be properly ended as customer at the table should still be addressed.

signal customer_has_been_processed
signal ending_commission_session

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
	_update_points_ui() # Update to most recent amount
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
	# Display customer in left widget and start dialog
	customer_display_UI.update_face(current_customer.face_sprite)
	customer_display_UI.start_dialog(current_customer.dialogue["greetings"])
	# Display commission/artifact submmission + actions UI elements 
	if !customer.is_returning:
		actions_UI.enable_request_actions()
		commission_dispay_UI.update_commission_display(current_customer.commission)
	elif customer.is_returning:
		actions_UI.enable_submission_actions()
		commission_dispay_UI.update_commission_display(current_customer.commission)
		commission_dispay_UI.time_display.text = "HERE TO COLLECT!" # Just to test that we can identify returning and not returning
	else:
		push_error("Boolean is_returning has a none truth value!")

func order_accepted() -> void:
	# Save customer to return
	
	current_customer.is_returning = true
	current_customer.return_day = current_day + current_customer.patience
	print("Order has been accepted! Customer returning: ", current_customer.return_day)
	
	_add_customer_to_booklist(current_customer)
	_add_commission_to_booklist(current_customer.commission)
	
	# Make customer leave
	customer_responded_to()
	
	# TODO: Save data
	
func order_rejected() -> void:
	print("Order has been rejected")
	# Make customer leave
	customer_responded_to()
	
	# TODO: Save data

func artifact_returned() -> void:
	var is_commission_returned = false
	for commission in commission_booklist:
		if commission == current_customer.commission and commission.is_completed == true:
			print("Commission completed and returned")
			_remove_commission_from_booklist(commission)
			_remove_customer_from_booklist(current_customer)
			player_points += commission.reward
			is_commission_returned = true
			
			break
	if !is_commission_returned:
		print("Commission has been failed!!!")
		_remove_commission_from_booklist(current_customer.commission)
		_remove_customer_from_booklist(current_customer)
	
	_update_points_ui()
	# Make customer leave
	customer_responded_to()
	
func commission_failed() -> void:
	print("Commission Failed!")
	# Make customer leave
	customer_responded_to()
	
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
	#print("Customer Service has ENDED!")
	current_day += 1
	print(customers_booklist)
	
	$TransitionToNextDay.start()
	await $TransitionToNextDay.timeout
	#print("Emitting signal")
	emit_signal("ending_commission_session")
	#start_day()
	
func customer_responded_to() -> void:
	current_customer.leave_store()
	current_customer = null
	customer_display_UI.clear_face()
	commission_dispay_UI.clear_commission_display()
	emit_signal("customer_has_been_processed")

func _add_customer_to_booklist(customer: Customer) -> void:
	if !customers_booklist.has(current_customer.return_day):
		customers_booklist[current_customer.return_day] = []
	customers_booklist[current_customer.return_day].append(current_customer)

func _add_commission_to_booklist(commission: CommissionData) -> void:
	commission_booklist.append(commission)

func _remove_customer_from_booklist(customer_to_delete: Customer) -> void:
	var list_for_the_day: Array = customers_booklist[current_day]
	if list_for_the_day == null:
		push_warning("Attempted to remove customer ", customer_to_delete, " from invalid day: ", current_day)
	for index in range(len(list_for_the_day)):
		if list_for_the_day[index] == customer_to_delete:
			list_for_the_day.remove_at(index)
			print("Customer deleted: ", customer_to_delete)
			return
	push_warning("Failed to remove commission: ", customer_to_delete)
	return
	
func _remove_commission_from_booklist(commission_to_delete: CommissionData) -> void:
	for index in range(len(commission_booklist)):
		if commission_booklist[index] == commission_to_delete:
			commission_booklist.remove_at(index)
			print("Commission deleted: ", commission_to_delete)
			return
	push_warning("Failed to remove commission: ", commission_to_delete)
	return

func _update_points_ui() -> void:
	points_UI.text = str(player_points)
