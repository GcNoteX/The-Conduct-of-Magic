class_name CustomerServiceGameManager
extends Node


@export var customers_booklist: Dictionary = {}  # The total customer to keep track of between days
@export var commission_booklist: Array = []

# This will be replaced with resourcce data for the day. or the modular generation of customers.
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
	
	_initialize_booklist_customers()
	
func _initialize_booklist_customers() -> void:
	for day in customers_booklist:
		for customer in customers_booklist[day]:
			customer.send_order.connect(self.process_customer)

func start_day() -> void:
	PlayerData.day += 1
	actions_UI.end_day_button.disabled = false
	call_deferred("_update_points_ui") # Update to most recent amount
	# Reset the customers for the day
	customers_for_the_day = []
	
	# Add in all the customers whose commission makes them come back this day
	if customers_booklist.has(PlayerData.day):
		for customer_entity in customers_booklist[PlayerData.day]:
			customers_for_the_day.append(customer_entity)
			#customer_entity.send_order.connect(self.process_customer)
	
	# Insert in special customers for the day
	if GameConstants.SpecialCustomerList[PlayerData.location].has(PlayerData.day):
		if len(GameConstants.SpecialCustomerList[PlayerData.location][PlayerData.day]) > 0:
			for special_customer in GameConstants.SpecialCustomerList[PlayerData.location][PlayerData.day]:
				var special_customer_instance = load(special_customer).instantiate()
				special_customer_instance.send_order.connect(self.process_customer)
				customers_for_the_day.append(special_customer_instance)

	# Generate new customers if needed
	if len(customers_for_the_day) < 5: # The number of customers can be modified based on the days requirement in the GameConstants
		for i in range(5 - len(customers_for_the_day)):
			# Make a customer object
			var customer_instance = create_customer(GameConstants.Locations.ParentsWorkshop)
			# Connecting send order to porcess customer is done in creat customer
			customers_for_the_day.append(customer_instance)
			
			
	# Placing customers into the shop scene to be managed there on when and where to spawn
	# This line essentially starts the day as the 'shop' outputs signals from customers that the 
	# rest of the UI responds to.
	shop.initialize(customers_for_the_day)
	
func create_customer(location) -> Customer:
	# Make a customer object
	var customer_instance = Customer.create_customer(location)
	customer_instance.send_order.connect(self.process_customer)
	
	return customer_instance

# Things to do when the customer sends their order
func process_customer(target_customer: Customer) -> void:
	current_customer = target_customer
	
	#if customer.is_special:
		#current_customer.commission = current_customer.special_commission[0]
		
	# Display customer in left widget and start dialog
	customer_display_UI.update_face(current_customer.customer_face_animated_sprite)
	
	customer_display_UI.start_dialog(current_customer.dialogue["greetings"])

	# Display commission/artifact submmission + actions UI elements 
	if !current_customer.is_returning:
		actions_UI.enable_request_actions()
		commission_dispay_UI.update_commission_display(current_customer.commission)
	elif current_customer.is_returning:
		actions_UI.enable_submission_actions()
		commission_dispay_UI.update_commission_display(current_customer.commission)
		commission_dispay_UI.time_display.text = "HERE TO COLLECT!" # Just to test that we can identify returning and not returning
	else:
		push_error("Boolean is_returning has a none truth value!")

func order_accepted() -> void:
	
	current_customer.is_returning = true
	var return_day = PlayerData.day + current_customer.commission.commission_due_date
	print("Order has been accepted! Customer returning: ", return_day)
	
	_add_customer_to_booklist(current_customer, return_day)
	_add_commission_to_booklist(current_customer.commission)
	
	# Make customer leave
	customer_responded_to()
	
	# Note: Saving all customers accepted will only be done at the end of the day
	# Why: Commission are added to the booklist from save through determining which
	# customers have is_returning as 'true', if a player restarts a day after accepting
	# customers, this would save them for the future days, but then reload the day with a new set
	# of the same number of customers as before, essentially making too many customers returning for future
	# days.
	
func order_rejected() -> void:
	print("Order has been rejected")
	# Make customer leave
	customer_responded_to()

func artifact_returned() -> void:
	var is_commission_returned = false
	for commission in commission_booklist:
		if commission == current_customer.commission and commission.is_completed == true:
			print("Commission completed and returned")
			_remove_commission_from_booklist(commission)
			_remove_customer_from_booklist(current_customer)
			PlayerData.coins += commission.reward
			is_commission_returned = true
			
			break
	if !is_commission_returned:
		print("Commission has been failed!!!")
		_remove_commission_from_booklist(current_customer.commission)
		_remove_customer_from_booklist(current_customer)
	call_deferred("_update_points_ui")
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
	for customer_instance in customers_for_the_day.slice(0, shop.customers_spawned):
		if customer_instance != null and customer_instance != current_customer:
			customer_instance.leave_store()
	
	if current_customer != null:
		await customer_has_been_processed
	
	# TODO: Save booklists and player stats now.
	
	# TODO: Closing sequence
	#print("Customer Service has ENDED!")
	
	
	$TransitionToNextDay.start()
	await $TransitionToNextDay.timeout
	
	emit_signal("ending_commission_session")

func customer_responded_to() -> void:
	current_customer.leave_store()
	current_customer = null
	customer_display_UI.clear_face()
	commission_dispay_UI.clear_commission_display()
	emit_signal("customer_has_been_processed")

func _add_customer_to_booklist(customer_instance: Customer, return_day: int) -> void:
	if !customers_booklist.has(return_day):
		customers_booklist[return_day] = []
	customers_booklist[return_day].append(customer_instance)

func _add_commission_to_booklist(commission: CommissionData) -> void:
	commission_booklist.append(commission)

func _remove_customer_from_booklist(customer_to_delete: Customer) -> void:
	var list_for_the_day: Array = customers_booklist[PlayerData.day]
	if list_for_the_day == null:
		push_warning("Attempted to remove customer ", customer_to_delete, " from invalid day: ", PlayerData.day)
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
	
	var text = "Day: %d | Points: %d" % [PlayerData.day, PlayerData.coins] 
	points_UI.text = text
