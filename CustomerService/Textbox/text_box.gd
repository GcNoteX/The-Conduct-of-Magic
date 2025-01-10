class_name CustomTextBox
extends MarginContainer

@onready var label = $MarginContainer/Label
@onready var timer = $LetterDisplayTimer

const MAX_WIDTH = 256
const MIN_WIDTH = 16
var text = ""
var letter_index = 0

var letter_time = 0.03
var space_time = 0.06
var punctuation_time = 0.2

signal finished_displaying

func display_text(text_to_display: String) -> void:
	# This line to line 32 sets the text box to be large enough, then we use display letter
	# to generate the characters one at a time
	text = text_to_display
	label.text = text_to_display
	
	if (text.length() > MIN_WIDTH): # Careful with this, await resized is required when we ar ehandling texts larger than the default nine patch rect size in its scene on the editor
		await resized
		
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		label.autowrap_mode = TextServer.AUTOWRAP_WORD
		#print("I am making the wrap")
		await resized # Wait for resize of x
		#print("I escaped the resize for x")
		await resized # Wait for resize of y
		#print("I escaped the resize for y")
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.y
	
	label.text = ""
	_display_letter()
	
func _display_letter() -> void:
	label.text += text[letter_index]
	
	letter_index += 1
	if letter_index >= text.length():
		finished_displaying.emit()
		return

	match text[letter_index]:
		"!", ".", ",", "?":
			timer.start(punctuation_time)
		" ":
			timer.start(space_time)
		_:
			timer.start(letter_time)


func _on_letter_display_timer_timeout() -> void:
	_display_letter()

func clear_text_box() -> void:
	label.text = ""
