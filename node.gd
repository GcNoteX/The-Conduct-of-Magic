extends Node


@onready var timer: Timer = $Timer
@onready var label: Label =  $MarginContainer/Label

var x = 0
func _ready() -> void:
	
	print("lad".length())
	
func _on_label_resized() -> void:
	print("Resized!")
	
func _on_timer_timeout() -> void:
	
	label.text = "asdsafabdaiofjedwjnnshfusbfeifojvjijosefifjodd seffgdgsfgdgrtgwregsfb sdfedfrwefgrgtrwgretg"
