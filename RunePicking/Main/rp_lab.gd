class_name RPLab
extends Node2D

@onready var displayed_artifact: Sprite2D = $artifact

func change_displayed_artifact(new_artifact: ArtifactData) -> void:
	displayed_artifact.texture = new_artifact.sprite

func display_no_artifact() -> void:
	displayed_artifact.texture = null
