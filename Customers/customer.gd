class_name Customer
extends Area2D

var customer_name: String
# Which map the customer will be in
var spawn_location: GameConstants.Locations 
# Possible artifacts they may commission
var owned_artifacts: Array[String]
# How much they can pay the player for their job
var richness: float  = 1
# An added duration to how long it should take to solve the artifact before the customer comes back to receive
var patience: int = 3
# Accuracy in determining the runes on a comissioned artifact
var intelligence: int = 3
# Customer dialogue
var dialogue: Dictionary

var initialized = false # Check if everything has been properly intialized for the shop day

# Conditions to check for the customer's state
var waiting = false
var leaving = false

@onready var moving_reaction_time: Timer = $MovingReactionTime
@onready var testing_leaving_timer: Timer = $Testing_LeaveAfterOrder
@onready var detection_area: Area2D = $detection_area2

signal send_order(customer: Customer) #TODO: Resource for the orders

func fill_in_customer_data(data: CustomerData):
	# The reason that we do not directly use the CustomerData is it makes it easier to store in JSON later
	customer_name = data.name
	spawn_location = data.spawn_location
	owned_artifacts = data.owned_artifacts
	richness = data.richness
	patience = data.patience
	intelligence = data.intelligence
	dialogue = data.dialogue # TODO: Maybe for general customer make a constant file of dialogue so no redundant saves of dialogue text

func _ready() -> void:
	initialized = true

func _process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if leaving:
		move_left()
	elif !waiting:
		move_right()
	
func move_right() -> void:
	position.x = position.x + 2

func move_left() -> void:
	position.x = position.x - 2	

func determine_customer_action(body: Node2D) -> void:
	# Stop customer from moving
	waiting = true
	
	# Actions depending on condition
	if body is CS_Player:
		#print("I have reached the front! Let me send my order")
		emit_signal("send_order", self)
		
	elif body is Customer:
		# Actions if there is a customer in front.
		#print("Customer ahead, lets wait...")
		pass
	else:
		print("Unidentified body has been collided with! -> ", body)
		
func leave_store() -> void:
	if !leaving:
		# self only has a layer it is on, the other area 2D is used to do the collision
		# Setting the attributes below to 0 pretty much makes it exist on no layers and checks no masks
		self.collision_layer = 0
		detection_area.collision_mask = 0
		self.scale.x = -1 # inverts the node
		
		# TODO: Ensure anything we need to save from the customer is done before it is destroyed in queue_free 
		# when it leaves the store

		leaving = true
	
func _on_detection_area_2_area_entered(area: Area2D) -> void:
	#print(area, " entered")
	determine_customer_action(area)

func _on_detection_area_2_area_exited(area: Area2D) -> void:
	#print(area, " exited")
	# Check if its another customer
	if area is Customer:
		moving_reaction_time.start()
		await moving_reaction_time.timeout
		#print("Start moving")
		waiting = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	self.queue_free()
