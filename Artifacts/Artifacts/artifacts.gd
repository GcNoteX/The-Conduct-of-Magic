class_name ArtifactData
extends Resource

@export_category("Artifact Information")
@export var name: String
@export var sprite: Texture2D

@export_category("Artifact Runes")
@export var max_number_of_runes: int
@export var rune_table: Array[RuneStats] # Or the number of runes runs out first

@export_category("Rune map")
# Will contain the runes, each index will contain the RuneStats(index 0) , its position (Vector2) (index 1)
@export var rune_map: Array[Array]
