class_name Customer
extends Area2D

var customer_id: int

@export_category("General")
@export var customer_name: String
@export var customer_class: String

@export var customer_tscn_path: String

## Which map the customer will be in
@export var spawn_location: GameConstants.Locations 
## Customer dialogue
@export var dialogue: Dictionary
@export var commission: CommissionData

## Dictates the behaviour of the customer when making comissions.
@export_category("Personality")
## How much they can pay the player for their job
@export_range(0, 3, 0.1) var richness: float  = 1
## An added duration to how long it should take to solve the artifact before the customer comes back to receive
@export_range(0, 5, 1) var patience: int = 3
## Accuracy in determining the runes on a comissioned artifact
@export_range(0, 5, 1) var intelligence: int = 3

# Non special customers will be generated by the game
@export_category("Special Characters")
@export var is_special: bool = false
@export_range(0, 5, 1) var favorability: int = 0

var is_returning: bool = false
# Conditions to check for the customer's state
var waiting
var leaving

@onready var customer_face_animated_sprite: AnimatedSprite2D = $FaceAnimatedSprite2D
@onready var customer_body_animated_sprite: AnimatedSprite2D = $BodyAnimatedSprite2D
@onready var moving_reaction_time: Timer = $MovingReactionTime
@onready var testing_leaving_timer: Timer = $Testing_LeaveAfterOrder
@onready var detection_area: Area2D = $detection_area2

signal send_order(customer: Customer) #TODO: Resource for the orders

static func create_customer(location: int) -> Customer:
	# Select an Artifact (Will be later stored through a commission)
	var artifact: ArtifactData = GameConstants.get_random_artifact(location)
	var selected_customer_class = artifact.class_owners[randi() % len(artifact.class_owners)]
	
	# Determine	the customer's class from the artifact
	var customers_class_data_path: String = GameConstants.customer_class_path + selected_customer_class + ".tres"
	var customer_class_data: CustomerClass = load(customers_class_data_path)
	
	# Determine the sprite set used for that customer to instantiate the correct child Customer tscn
	var sprite_set = customer_class_data.get_class_sprite_set(artifact.name)
	var customer_tscn_path = GameConstants.customer_scenes_path + sprite_set + ".tscn"
	
	# Load the Customer scene
	var packed_customer_scene = load(customer_tscn_path)
	var customer_instance = packed_customer_scene.instantiate() as Customer  # Cast to Customer
	
	# Determine through class
	var generic_names = customer_class_data.possible_names
	customer_instance.customer_name = generic_names[randi() % len(generic_names)]
	customer_instance.customer_id = randi() # Just for easier checking for unique characters with same sprite,
	customer_instance.spawn_location = location
	
	customer_instance.customer_class = selected_customer_class
	customer_instance.customer_tscn_path = customer_tscn_path
	
	customer_instance.dialogue = customer_class_data.get_class_dialogue_set(artifact.name)
	
	# TODO: Modify based on the sprite_set
	customer_instance.richness = round(randf_range(customer_class_data.min_richness, customer_class_data.max_richness))
	customer_instance.patience = randi_range(customer_class_data.min_patience, customer_class_data.max_patience)
	customer_instance.intelligence = randi_range(customer_class_data.min_intelligence, customer_class_data.max_intelligence)
	
	# TODO: Commission	
	customer_instance.commission = CommissionData.create_commission(customer_instance, customer_class_data, artifact)

	return customer_instance

static func cast_data_to_customer_instance(data: Dictionary) -> Customer:
	# Load the Customer scene
	var packed_customer_scene = preload("res://Customers/customer.tscn")
	var customer_instance = packed_customer_scene.instantiate() as Customer  # Cast to Customer
	
	customer_instance.customer_id = data["customer_id"]
	customer_instance.customer_name = data["customer_name"]
	customer_instance.customer_class = data["customer_class"]
	customer_instance.customer_tscn_path = data["customer_tscn_path"]

	customer_instance.spawn_location = data["spawn_location"]
	customer_instance.dialogue = data["dialogue"]
	
	customer_instance.commission = CommissionData.cast_data_to_commission_instance(data["commission"]) #TODO: This thing is suppose to be CommssionData, will need to load customers after commissions
	
	customer_instance.richness = data["richness"]
	customer_instance.patience = data["patience"]
	customer_instance.intelligence = data["intelligence"]
	
	# TODO: These two items may need to be moved once we integrated special customers
	customer_instance.is_special = data["is_special"] # save is_special as 1 or 0
	customer_instance.favorability = data["favorability"]
	
	customer_instance.is_returning = data["is_returning"]

	return customer_instance

static func cast_customer_data_to_dict(customer: Customer) -> Dictionary:
	var content = {
		"customer_id": customer.customer_id,
		"customer_name": customer.customer_name,
		"customer_class": customer.customer_class,
		"customer_tscn_path": customer.customer_tscn_path,
		"spawn_location": customer.spawn_location, 
		"dialogue": customer.dialogue,  # Assuming dialogue is a Dictionary
		"richness": customer.richness,
		"patience": customer.patience,
		"intelligence": customer.intelligence,
		"is_special": customer.is_special,
		"favorability": customer.favorability,
		"is_returning": customer.is_returning,
		"commission": CommissionData.cast_commission_data_to_dict(customer.commission)
	}
	
	return content

func _process(_delta: float) -> void:
	# Simply to control the movement direction of the customer
	if leaving:
		move_left()
	elif !waiting:
		move_right()
	
func move_right() -> void:
	position.x = position.x + 4

func move_left() -> void:
	position.x = position.x - 4

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
	
	call_deferred("_initialize_animation")

func _initialize_animation() -> void:
	customer_body_animated_sprite.play("walking")

func leave_store() -> void:
	if !leaving:
		# self only has a layer it is on, the other area 2D is used to do the collision
		# Setting the attributes below to 0 pretty much makes it exist on no layers and checks no masks
		self.collision_layer = 0
		detection_area.collision_mask = 0
		self.scale.x = -1 # inverts the node

		leaving = true
		customer_body_animated_sprite.play("walking")

func _on_detection_area_2_area_entered(area: Area2D) -> void:
	# Stop customer from moving
	waiting = true
	customer_body_animated_sprite.play("waiting")
	determine_customer_action(area)

func _on_detection_area_2_area_exited(area: Area2D) -> void:
	# Check if its another customer and start moving again
	if area is Customer: # The reason to check for a Customer is incase you exit the players hitbox
		moving_reaction_time.start()
		await moving_reaction_time.timeout
		waiting = false
		customer_body_animated_sprite.play("walking")

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	if is_returning:
		var parent_node = get_parent()
		parent_node.remove_child(self)
	else:
		queue_free()

func _assign_collision_layers_and_masks():
	self.collision_layer = 1 << 3
	detection_area.collision_mask = (1 << 1) | (1 << 3)

func _to_string() -> String:
	if is_special:
		return "Special Customer - %s (ID: %d)" % [customer_name, get_instance_id()]
	else:
		return "Customer - %s (ID: %d)" % [customer_name, get_instance_id()]
