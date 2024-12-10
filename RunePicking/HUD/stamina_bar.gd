class_name StaminaBar
extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value = progress_bar.max_value


func update_stamina(new_value: float) -> void:
	progress_bar.value = new_value
