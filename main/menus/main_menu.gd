class_name MainMenu
extends Control

@onready var play_button: Button = $MarginContainer/VBoxContainer/PlayButton
@onready var new_game_button: Button = $MarginContainer/VBoxContainer/NewGameButton
@onready var settings_button: Button = $MarginContainer/VBoxContainer/SettingsButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/QuitButton

signal play_game
signal instantiate_new_game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Check if there is a save file, disable play button if none.
	update_play_button_state()
	pass # Replace with function body.

func _on_play_button_pressed() -> void:

	emit_signal("play_game")
	pass # Replace with function body.


func _on_new_game_button_pressed() -> void:
	print("New game")
	SaveManager.create_new_save_file()
	PlayerData.load_player_data()
	update_play_button_state()
	emit_signal("instantiate_new_game")
	pass # Replace with function body.


func _on_settings_button_pressed() -> void:
	pass # Replace with function body.


func _on_quit_button_pressed() -> void:
	pass # Replace with function body.

func update_play_button_state() -> void:
	if !SaveManager.check_if_save_exists():
		play_button.disabled = true
	else:
		play_button.disabled = false
