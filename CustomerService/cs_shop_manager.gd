class_name ShopManager
extends Node2D

var customer_spawn_position: Vector2 = Vector2(100, 200)
var customers: Array[Customer] = [] 
var initialized: bool = false
var day_ended: bool = false
var customer_count: int
var customers_spawned: int = 0

# Called when the node enters the scene tree for the first time.
func initialize(customers_for_shop: Array[Customer]) -> void:
	customers = customers_for_shop
	customer_count = len(customers)
	$CustomerSpawnInterval.start()
	initialized = true



func _send_customer_to_shop(customer: Customer) -> void:
	self.add_child.call_deferred(customer)
	customer.position = customer_spawn_position
	print(customer.customer_name, "," ,customer.commission.artifact.name, ",", customer.patience, ",", customer.commission.commission_due_date, ",", customer.richness, "," ,customer.commission.reward, "," ,customer.commission.speculative_runes)
	customers_spawned += 1


func _on_customer_spawn_interval_timeout() -> void:
	if customers_spawned < customer_count and !day_ended:
		#var next_customer = customers.pop_front()
		_send_customer_to_shop(customers[customers_spawned])
	else:
		$CustomerSpawnInterval.stop()
