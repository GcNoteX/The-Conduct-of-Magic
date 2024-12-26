class_name RpPlayer
extends CharacterBody2D


@export var speed = 1500
@onready var trail = $trail
@onready var death_timer = $death_timer
@onready var player_sprite = $cursor_sprite

var previous_position: Vector2
var max_player_vel: int = 10000
var follow: bool = false


func _ready() -> void:
	# Hide Mouse
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	# get previous position as current positon
	self.visible = false
	pass

func _physics_process(delta: float) -> void:
	if follow:
		# get velocity
		velocity = (get_global_mouse_position() - position) * speed * delta
		
		# Cap the speed
		velocity = Vector2(clamp(velocity.x, -max_player_vel, max_player_vel), clamp(velocity.y, -max_player_vel, max_player_vel))
		
		# Clicking
		if Input.is_action_just_pressed("left_click"):
			$MouseAnimation.play("click")
			$CPUParticles2D.emitting = true
		
		# Put a trail onto my cursor
		#trail.add_point(get_global_mouse_position())
		previous_position = self.position
		
		move_and_slide()
		
		
func _on_mouse_animation_animation_finished(anim_name: StringName) -> void:
	if anim_name == "click":
		$MouseAnimation.play("idle")

func kill_player_cursor() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	death_timer.start()
	await death_timer.timeout
	print("Player has visually died, removing sprite")
	player_sprite.queue_free()
	follow = false

func get_player_speed() -> float:
	var change_in_pos = self.position - previous_position
	return change_in_pos.length()

func enable_player_cursor() -> void:
	self.visible = true
	self.position = get_global_mouse_position()
	previous_position = self.position
	follow = true
	self.collision_layer = 1 << 1  # Assign to layer 2
	
func disable_player_cursor() -> void:
	self.visible = false
	follow = false
	self.collision_layer = 0
	
