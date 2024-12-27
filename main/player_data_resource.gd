class_name PlayerDataResource
extends Resource

@export var coins: int
@export var stamina: float
@export var customers_booklist: Dictionary = {} # The total customer to keep track of between days
@export var commission_booklist: Array[CommissionData] = []
