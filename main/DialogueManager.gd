extends Node

@onready var text_box_scene: PackedScene = preload("res://CustomerService/Textbox/text_box.tscn")

var dialog_lines: Array = []
var current_line_index = 0

var text_box
var text_box_position: Vector2

var is_dialog_active = false
var can_advance_line = false

func start_dialog(position: Vector2,  lines: Array) -> void:
	if is_dialog_active: # As to not start another dialogue during current one
		return
	
	dialog_lines = lines
	text_box_position = position
	_show_text_box()
	
	is_dialog_active = true
	
func _show_text_box() -> void:
	text_box = text_box_scene.instantiate() as CustomTextBox
	text_box.finished_displaying.connect(_on_text_box_finished_displaying)
	get_tree().root.add_child.call_deferred(text_box)
	text_box.global_position = text_box_position
	
	
	
	text_box.call_deferred("display_text", dialog_lines[current_line_index])
	#can_advance_line = false # Needed if moving to next dialogue wants to use user input

func _on_text_box_finished_displaying() -> void:
	#can_advance_line = true
	
	await _pause_dialogue_timer()
	if is_dialog_active:
		text_box.queue_free()
		
		current_line_index += 1
		if current_line_index >= dialog_lines.size():
			is_dialog_active = false
			current_line_index = 0
			return
		
		_show_text_box()
	
func _pause_dialogue_timer() -> void:
	var timer = Timer.new()
	timer.wait_time = 1.0  # Set to 1 second
	timer.one_shot = true  # Ensure it runs only once
	add_child(timer)  # Add the timer to the scene tree
	timer.start()
	await timer.timeout
	
func _unhandled_input(_event: InputEvent) -> void:
	#if (
		#event.is_action_pressed("left_click") &&
		#is_dialog_active &&
		#can_advance_line
	#):
		#text_box.queue_free()
		#
		#current_line_index += 1
		#if current_line_index >= dialog_lines.size():
			#is_dialog_active = false
			#current_line_index = 0
			#return
		#
		#_show_text_box()
	pass
