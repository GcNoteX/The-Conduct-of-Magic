class_name RPLab
extends Node2D

@onready var displayed_artifact: Sprite2D = $artifact
@onready var player_in_lab: Area2D = $CsPlayer

func change_displayed_artifact(new_artifact: ArtifactData) -> void:
	displayed_artifact.texture = new_artifact.sprite

func display_no_artifact() -> void:
	displayed_artifact.texture = null

func disable_collission_and_visibility() -> void:
	self.visible = false
	player_in_lab.monitorable = false
	player_in_lab.monitoring = false

func enable_collission_and_visibility() -> void:
	self.visible = true
	player_in_lab.monitorable = true
	player_in_lab.monitoring = true
