extends Node2D
class_name YellowSpark

@onready var sfx_activate_node = $sfx_activate_node
@onready var is_activated = false

signal spark_collected(pos: Vector2)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(get_global_mouse_position())
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !is_activated:
		is_activated = true
		print("Spark has been activated.")
		$AnimatedSprite2D.play("Awakened Rotating")
		sfx_activate_node.play()
		
		emit_signal("spark_collected", position)


func _on_area_2d_mouse_entered() -> void:
	if Input.get_mouse_mode() == 0:
		print("Area entered")
		$AnimatedSprite2D.play("Awakened Blinking")

func _on_area_2d_mouse_exited() -> void:
	if Input.get_mouse_mode() == 0:
		print("Area exited")
		$AnimatedSprite2D.play("Sealed")
