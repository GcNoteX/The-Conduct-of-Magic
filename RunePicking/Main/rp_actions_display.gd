class_name RpActionsDisplay
extends PanelContainer

@onready var start_rp_button: Button = $MarginContainer/ActionsList/StartRunePickingButton
@onready var end_session_button: Button = $MarginContainer/ActionsList/EndSessionButton

signal start_rune_picking
signal end_session

func _on_start_rune_picking_button_pressed() -> void:
	emit_signal("start_rune_picking")

func _on_end_session_button_pressed() -> void:
	emit_signal("end_session")
