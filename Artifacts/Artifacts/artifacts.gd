class_name Artifact
extends Resource

@export_category("Artifact Information")
@export var name: String
@export var sprite: Texture2D

@export_category("Artifact Runes")
@export var max_number_of_runes: int
@export var runes: Array[RuneStats] # Or the number of runes runs out first
