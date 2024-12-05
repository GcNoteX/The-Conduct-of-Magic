class_name Customer
extends Area2D

var customer_id: int
var customer_name: String
var face_sprite: String
# Which map the customer will be in
var spawn_location: GameConstants.Locations 
# How much they can pay the player for their job
var richness: float 
# An added duration to how long it should take to solve the artifact before the customer comes back to receive
var patience: int
# Accuracy in determining the runes on a comissioned artifact
var intelligence: int 
# Customer dialogue
var dialogue: Dictionary
# Commission information
var commission: CommissionData
var return_day: int
var is_returning: bool = false


# Conditions to check for the customer's state
var waiting
var leaving

@onready var moving_reaction_time: Timer = $MovingReactionTime
@onready var testing_leaving_timer: Timer = $Testing_LeaveAfterOrder
@onready var detection_area: Area2D = $detection_area2

signal send_order(customer: Customer) #TODO: Resource for the orders

func fill_in_customer_data(data: CustomerData, location):
	data.prepare_character_data(location) # Fills in the customer resource with 'random' data
	# The reason that we do not directly use the CustomerData is it makes it easier to store in JSON later
	customer_id = randi()
	customer_name = data.name
	face_sprite = data.face_sprite
	spawn_location = data.spawn_location
	richness = data.richness
	patience = data.patience
	intelligence = data.intelligence
	dialogue = data.dialogue # TODO: Maybe for general customer make a constant file of dialogue so no redundant saves of dialogue text
	commission = data.commission

func _process(delta: float) -> void:
	# Simply to control the movement direction of the customer
	if leaving:
		move_left()
	elif !waiting:
		move_right()
	
func move_right() -> void:
	position.x = position.x + 2

func move_left() -> void:
	position.x = position.x - 2	

func determine_customer_action(body: Node2D) -> void:
	# Actions depending on condition
	if body is CS_Player:
		emit_signal("send_order", self)
		
	elif body is Customer:
		# Actions if there is a customer in front.
		pass
	else:
		push_warning("Unidentified body has been collided with! -> ", body)

func enter_store() -> void:
	# Reset values - these values may had been modified when the player had left the store but is coming back.
	waiting = false
	leaving = false
	
	self.scale.x = 1
	call_deferred("_assign_collision_layers_and_masks")
	

func leave_store() -> void:
	if !leaving:
		# self only has a layer it is on, the other area 2D is used to do the collision
		# Setting the attributes below to 0 pretty much makes it exist on no layers and checks no masks
		self.collision_layer = 0
		detection_area.collision_mask = 0
		self.scale.x = -1 # inverts the node

		leaving = true
	
func _on_detection_area_2_area_entered(area: Area2D) -> void:
	# Stop customer from moving
	waiting = true
	
	determine_customer_action(area)

func _on_detection_area_2_area_exited(area: Area2D) -> void:
	# Check if its another customer and start moving again
	if area is Customer: # The reason to check for a Customer is incase you exit the players hitbox
		moving_reaction_time.start()
		await moving_reaction_time.timeout
		waiting = false

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_returning:
		remove_child(self)
	else:
		queue_free()

func _assign_collision_layers_and_masks():
	self.collision_layer = 1 << 3
	detection_area.collision_mask = (1 << 1) | (1 << 3)
