class_name RpLevelDisplay
extends Node

@export var rune_map: Array[Array]

@onready var rune: PackedScene = preload("res://RunePicking/Runes/general_rune.tscn")
@onready var level_physics_plane: Node2D = $LevelPhysicsPlane

@onready var player_data: PlayerDataResource = PlayerData.player_data
@onready var stamina: float = player_data.stamina

var total_number_of_runes: int = 0
var number_of_activated_runes: int = 0

signal exit_level_display(is_rune_map_completed: bool)

func _ready() -> void:
	# Construct Map
	# item[0] is the object's resource, item[1] is its Vector2 position on the level display
	for item in rune_map:
		if item[0] is RuneStats:
			var rune_instance = rune.instantiate() as Rune
			rune_instance.rune_data = item[0]
			rune_instance.position = item[1]
			rune_instance.rune_activated.connect(_rune_activated)
			
			level_physics_plane.add_child.call_deferred(rune_instance)
			total_number_of_runes += 1
	
	# Initialize the player with the correct stats	
func _rune_activated(rune: Rune) -> void:
	number_of_activated_runes += 1
	if number_of_activated_runes == total_number_of_runes:
		emit_signal("exit_level_display", true)
