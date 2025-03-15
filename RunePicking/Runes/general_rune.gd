class_name GeneralRune
extends Node2D

# General Rune Data
@export var rune_name: String # Name for UI reasons
@export var rune_dir: String # Name for the tscn associated with the rune
@export var stamina_recovered: float = 0

# Initialize variables used for rune picking
@onready var is_activated: bool = false

# Simplify references
@onready var rune_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var rune_collision_body: CollisionShape2D = $Area2D/CollisionShape2D
@onready var activate_rune_sfx: AudioStreamPlayer2D = $activate_rune_sfx

# Signals
signal rune_activated(rune: GeneralRune)

# Editor code
func _ready() -> void:
	rune_sprite.play("Sealed")

# Game code
func awaken_rune() -> void:
	if is_activated == false:
		#print(rune_data.rune_name, " has been activated.")
		rune_sprite.play("Awakened")
		activate_rune_sfx.play()
		is_activated = true
		emit_signal("rune_activated", self)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	awaken_rune()

# I Could delete the area 2d to shut off the signal for abit more performance if it has no more use.
