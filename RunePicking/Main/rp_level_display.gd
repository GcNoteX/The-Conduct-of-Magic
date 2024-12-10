class_name RpLevelDisplay
extends Node

@export var rune_map: Array[Array]

@onready var rune: PackedScene = preload("res://RunePicking/Runes/general_rune.tscn")
@onready var level_physics_plane: Node2D = $LevelPhysicsPlane

# Scenes variables and constants
const rune_picking_border: int = 100

func _ready() -> void:
	# item[0] is the object's resource, item[1] is its Vector2 position on the level display
	for item in rune_map:
		if item[0] is RuneStats:
			var rune_instance = rune.instantiate() as Rune
			rune_instance.rune_data = item[0]
			rune_instance.position = item[1]
			
			level_physics_plane.add_child.call_deferred(rune_instance)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
