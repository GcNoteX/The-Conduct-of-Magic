class_name RpStaminaBar
extends Control

@onready var progress_bar: ProgressBar = $ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_bar.value = PlayerData.stamina

func update_stamina(new_value: float) -> void:
	progress_bar.value = new_value

func decrease_stamina_bar(decrement: float) -> void:
	progress_bar.value = progress_bar.value - decrement

func increase_stamina_bar(increment: float) -> void:
	progress_bar.value = progress_bar.value + increment

func get_stamina_bar_value() -> float:
	return progress_bar.value
