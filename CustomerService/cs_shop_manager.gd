class_name ShopManager
extends Node2D

var customer_spawn_position: Vector2 = Vector2(100, 200)
var customers: Array[Customer] = [] 
var customer_count: int
var customers_spawned: int

var initialized: bool = false
var day_ended: bool = false

# MUST always be called to start/reset the shop
func initialize(customers_for_shop: Array[Customer]) -> void:
	customers = customers_for_shop
	customer_count = len(customers_for_shop)
	
	# Resets all the values for it to start once again.
	customers_spawned = 0
	day_ended = false
	$CustomerSpawnInterval.start()
	initialized = true
	

func _send_customer_to_shop(customer: Customer) -> void:
	self.add_child.call_deferred(customer)
	customer.enter_store()
	customer.position = customer_spawn_position
	
	print(customer.customer_id, " : ", customer.customer_name, ' | ', customer.commission.commission_due_date)
	customers_spawned += 1

func _on_customer_spawn_interval_timeout() -> void:
	# The function which puts the customers in the shop
	if customers_spawned < customer_count and !day_ended:
		#var next_customer = customers.pop_front()
		_send_customer_to_shop(customers[customers_spawned])
	else:
		$CustomerSpawnInterval.stop()
