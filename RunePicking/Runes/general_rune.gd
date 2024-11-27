#@tool
class_name Rune
extends Node2D

@export var rune_data: RuneStats

# Initialize variables
@onready var is_activated: bool = false
@onready var rune: RuneStats = rune_data
@onready var rune_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var rune_collision_body: CollisionShape2D = $Area2D/CollisionShape2D
@onready var activate_rune_sfx: AudioStreamPlayer2D = $activate_rune_sfx

# Signals
signal rune_activated(rune: Rune)
# Signals for starting the game
signal mouse_entered_rune(rune: Rune)
signal mouse_exited_rune(rune: Rune)

# Editor code
func _ready() -> void:
	# Initialization, may make different sets based on collision shape in the future.
	if rune_data != null:
		rune_sprite.sprite_frames = rune.frames
		rune_sprite.modulate = rune.rune_modulate_color
		rune_collision_body.shape = rune.shape
		rune_collision_body.shape.radius = rune.radius
		activate_rune_sfx.stream = rune.awakened_sfx
		self.scale = Vector2(rune_data.scale, rune_data.scale)
		rune_sprite.play("Sealed")
	else:
		print("rune_data failed to export for ", self)
		self.queue_free()

# Game code
func awaken_rune() -> void:
	if is_activated == false:
		print(rune.rune_name, " has been activated.")
		rune_sprite.play("Awakened")
		activate_rune_sfx.play()
		is_activated = true
		emit_signal("rune_activated", self)

func _on_area_2d_body_entered(body: Node2D) -> void:
	awaken_rune()

# I Could delete the area 2d to shut off the signal for abit more performance if it has no more use.


func _on_area_2d_mouse_entered() -> void:
	#print("Entered rune detected by rune")
	emit_signal("mouse_entered_rune", self)


func _on_area_2d_mouse_exited() -> void:
	#print("Exiting rune detected by rune")
	emit_signal("mouse_exited_rune", self)
