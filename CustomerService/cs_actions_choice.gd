class_name ActionsUI
extends PanelContainer

var actions_available: bool = false

@onready var accept_button: Button = $MarginContainer/VBoxContainer/Accept_Button
@onready var reject_button: Button = $MarginContainer/VBoxContainer/Reject_Button
@onready var end_day_button: Button = $MarginContainer/VBoxContainer/End_Day_Button

signal accepting_request
signal rejecting_request
signal ending_day

# Function when request is accepted
func _on_accept_button_pressed() -> void:
	disable_actions()
	emit_signal("accepting_request")
	#print("Pressed")

# Function when request is rejected
func _on_reject_button_pressed() -> void:
	disable_actions()
	emit_signal("rejecting_request")
	#print("Pressed")

func _on_end_day_button_pressed() -> void:
	end_day_button.disabled = true
	emit_signal("ending_day")

func enable_actions() -> void:
	if !actions_available: # If actions are currently disabled
		accept_button.disabled = false
		reject_button.disabled = false
		
		actions_available = true
	else:
		push_warning("Enabling actions had occured twice in a row!")

func disable_actions() -> void:
	if actions_available:
		accept_button.disabled = true
		reject_button.disabled = true
		
		actions_available = false
	else:
		push_warning("Disabling actions had occured twice in a row!")
