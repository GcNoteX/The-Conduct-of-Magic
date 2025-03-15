class_name RpLevelDisplay
extends Node

@export var rune_map: Array[Array]

@onready var rune: PackedScene = preload("res://RunePicking/Runes/general_rune.tscn")
@onready var level_physics_plane: Node2D = $LevelPhysicsPlane
@onready var player_cursor: RpPlayer = $LevelPhysicsPlane/Player
@onready var staminar_bar: RpStaminaBar = $CanvasLayer/StaminaBar

var total_number_of_runes: int = 0
var number_of_activated_runes: int = 0
var active_stamina_decrement: float = 0
var passive_stamina_decrement: float = 3
var playing = false


signal exit_level_display(is_rune_map_completed: bool)

func _ready() -> void:
	# Construct Map
	# item[0] is the object's resource, item[1] is its Vector2 position on the level display
	for item in rune_map:
		if item[0].contains("rune"):
			var rune_instance = _generate_rune_as_appropriate_class(item[0])
			rune_instance.position = item[1]
			rune_instance.rune_activated.connect(_rune_activated)
			
			level_physics_plane.add_child.call_deferred(rune_instance)
			total_number_of_runes += 1

func _generate_rune_as_appropriate_class(rune_dir: String):
	var full_path = GameConstants.rune_types_path + rune_dir + ".tscn"
	var rune_tscn = load(full_path)
	var rune_instance = rune_tscn.instantiate()
	
	# TODO: This set will increase as we get more runes
	if rune_dir == "basic_rune":
		rune_instance = rune_instance as BasicRune

	return rune_instance

func _rune_activated(rune_instance: GeneralRune) -> void:
	number_of_activated_runes += 1
	staminar_bar.increase_mana(rune_instance.stamina_recovered)
	
	if number_of_activated_runes == total_number_of_runes:
		
		_leave_level_display(true)
		

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):  # Check if the left mouse button is clicked
		
		var mouse_position = get_viewport().get_mouse_position()
		var space_state = level_physics_plane.get_world_2d().direct_space_state
		var query = PhysicsPointQueryParameters2D.new()
		query.position = mouse_position
		query.collide_with_areas = true
		var answer = space_state.intersect_point(query)
		if len(answer) == 1 and answer[0]['collider'].is_in_group('rune'):
			print("It is rune!")
			enable_play()
	
	if playing:
		# Stamina draining
		active_stamina_decrement = player_cursor.get_player_speed() * delta
		staminar_bar.decrease_mana(active_stamina_decrement + passive_stamina_decrement * delta)

func _leave_level_display(is_rune_map_completed: bool) -> void:
	# Pause for animations and view
	playing = false
	$LeaveDisplayTimer.start()
	await $LeaveDisplayTimer.timeout
	# Close the game
	emit_signal("exit_level_display", is_rune_map_completed)

func enable_play() -> void:
	playing = true
	player_cursor.enable_player_cursor()
	
func disable_play() -> void:
	playing = false
	player_cursor.disable_player_cursor()


func _on_area_2d_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
