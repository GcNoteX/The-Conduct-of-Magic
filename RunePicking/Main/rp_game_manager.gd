class_name RunePickingGameManager
extends Node

# Exports and preloading items
@export var artifact_data: ArtifactData

# Initializing variables
var can_start_playing: bool = false
var game_started: bool = false
var starting_positon: Vector2 = Vector2(-1, -1)
var is_alive: bool = true
var map_solved: bool = false
var stamina: float = 100.0
var passive_drain: float = 5
var active_drain: float = 20
var previous_position: Vector2 = Vector2(-1, -1)
var awakened_runes_count: int = 0
var total_runes_count: int = 0

@onready var player = $Player as RpPlayer
@onready var player_hitbox = $Player/cursor_collision_box as CollisionShape2D
@onready var stamina_bar = $CanvasLayer/StaminaBar as StaminaBar
@onready var rune_map = $RpMapGenerator as RunePickingMapGenerator
@onready var UI_elements = $CanvasLayer as CanvasLayer


# signals
signal update_stamina_bar(new_value: float)
signal stamina_ran_out

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UI_elements.offset = get_tree().current_scene.position
	UI_elements.scale - get_tree().current_scene.scale
	
	# Register to rune map the artifact to use
	rune_map.intiailize(artifact_data)
	
	# Disable player cursor for start
	player.visible = true
	player_hitbox.disabled = true
	
	self.update_stamina_bar.connect(stamina_bar.update_stamina)
	
	for item in rune_map.runes:
		var rune = item as Rune
		if rune != null:
			rune.rune_activated.connect(self.awakened_rune_effect)
			rune.mouse_entered_rune.connect(self.mouse_entered_rune2)
			rune.mouse_exited_rune.connect(self.mouse_exited_rune2)
			total_runes_count += 1
		else:
			push_warning("Item in runes of rune map is not a rune!")
	
	self.stamina_ran_out.connect(player.player_stamina_zero)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !map_solved and game_started:
		if previous_position != Vector2(-1, -1):
			# Determine stamina drain from movement
			var change_in_position = player.position - previous_position
			previous_position = player.position
			# Update stamina
			stamina -= passive_drain * delta + change_in_position.length() * delta * active_drain
			stamina = clamp(stamina, 0, stamina_bar.progress_bar.max_value)
			emit_signal("update_stamina_bar", stamina)
		else:
			previous_position = player.position
		
		if stamina == 0 and is_alive: # When the player runs out of stamina
			print("You have died")
			is_alive = false
			# Lock cursor
			emit_signal("stamina_ran_out")

func awakened_rune_effect(rune: Rune) -> void:
	# Tally runes awakaned
	awakened_runes_count += 1
	if awakened_runes_count == total_runes_count:
		print("Rune map has been solved!")
		map_solved = true
		# TODO: Code for completion
		
		return
	
	# Stamina recovered
	stamina += rune.rune_data.stamina_recovered
	stamina = clamp(stamina, 0, stamina_bar.progress_bar.max_value)

	# TODO: Custom code for specific runes should be done

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("left_click") and !game_started and can_start_playing:
		# Check if it is valid place to start
		
		# Perform a collision check at the click position
		
		# Enable mouse for game
		print("Enabling Mouse")
		player.visible = true
		player_hitbox.disabled = false
		
		# Disable current mouse
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		
		# Orient mouse for start and maybe some animation
		player.position
		
		game_started = true
		
		
func mouse_entered_rune2(rune: Rune) -> void:
	if !game_started:
		can_start_playing = true
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		starting_positon = rune.global_position
	
func mouse_exited_rune2(rune: Rune) -> void:
	if !game_started:
		can_start_playing = false
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		starting_positon = Vector2(-1, -1)
