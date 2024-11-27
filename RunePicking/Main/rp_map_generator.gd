class_name RunePickingMapGenerator
extends Node

# Exports and preloading items
@export var artifact_data: Artifact
@onready var rune: PackedScene = preload("res://RunePicking/Runes/general_rune.tscn")

# Scenes variables and constants
const rune_picking_border: int = 100
var runes: Array[Rune] = []

func _ready() -> void:
	pass

func intiailize(artifact_data: Artifact) -> void:
	# Generate placements for runes
	for i in range(artifact_data.max_number_of_runes): # TODO: Should I make the number of runes random?
		# Get a random rune from possible runes for the artifact
		var random_index = randi_range(0, artifact_data.runes.size() - 1)
		var random_rune = artifact_data.runes[random_index]
		
		# Instantiate rune from resource # TODO: Difference instantiation if special runes 
		var rune_instance = rune.instantiate() as Rune
		rune_instance.rune_data = random_rune
		
		# Place rune on map
		get_tree().current_scene.add_child.call_deferred(rune_instance)
		var position_instance = _get_random_position()
		rune_instance.position = position_instance # TODO: Make sure runes do not collide, maybe make the random positions follow a range
		
		# Save rune for signal connections of game manger
		runes.append(rune_instance)
		
		
func _get_random_position() -> Vector2:
	# Step 1: Get the screen size
	var screen_size = DisplayServer.window_get_size()

	# Step 2: Generate a random position within the screen size
	var random_x = randf_range(0 + rune_picking_border, screen_size.x - rune_picking_border)
	var random_y = randf_range(0 + rune_picking_border, screen_size.y - rune_picking_border)
	var random_position = Vector2(random_x, random_y)
	return random_position
