class_name RpStaminaBar
extends Control

@onready var progress_bar: ProgressBar = $ProgressBar


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value = PlayerData.mana

func set_mana(new_value: float) -> void:
	PlayerData.mana = new_value
	progress_bar.value = round(PlayerData.mana)
	
func increase_mana(increment: float) -> void:
	PlayerData.mana += increment
	progress_bar.value = PlayerData.mana
	
func decrease_mana(increment: float) -> void:
	PlayerData.mana -= increment
	progress_bar.value = PlayerData.mana
