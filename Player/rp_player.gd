class_name RunePickingPlayer
extends CharacterBody2D


@export var speed = 1500
@onready var trail = $trail
@onready var death_timer = $death_timer
@onready var player_sprite = $cursor_sprite
var once = true
var follow: bool = true
var rotation_direction = 0
var max_player_vel: int = 10000

func _ready() -> void:
	# Hide Mouse
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func _physics_process(delta: float) -> void:
	if follow:
		# get velocity
		velocity = (get_global_mouse_position() - position) * speed * delta
		
		# Cap the speed
		velocity = Vector2(clamp(velocity.x, -max_player_vel, max_player_vel), clamp(velocity.y, -max_player_vel, max_player_vel))
		move_and_slide()
		
		# Clicking
		if Input.is_action_just_pressed("left_click"):
			$MouseAnimation.play("click")
			$CPUParticles2D.emitting = true
		elif once:
			$MouseAnimation.play("idle")
			once = false
		
		# Put a trail onto my cursor
		#trail.add_point(get_global_mouse_position())
		
func _on_mouse_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "click":
		$MouseAnimation.play("idle")

func player_stamina_zero() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	death_timer.start()
	follow = false

func _on_death_timer_timeout() -> void:
	print("Player has visually died, removing sprite")
	player_sprite.queue_free()
	pass
