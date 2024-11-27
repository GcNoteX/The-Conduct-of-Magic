class_name Customer
extends Area2D


const SPEED = 550.0
const JUMP_VELOCITY = -400.0

var waiting = false
var leaving = false
var initialized = false

@onready var moving_reaction_time: Timer = $MovingReactionTime
@onready var testing_leaving_timer: Timer = $Testing_LeaveAfterOrder
@onready var detection_area: Area2D = $detection_area2

signal send_order(customer: Customer) #TODO: Resource for the orders

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
