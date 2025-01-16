class_name CustomerDisplay
extends PanelContainer

@onready var customer_face: TextureRect = $MarginContainer/CustomerFace
@onready var animated_customer_face: AnimatedSprite2D = $AnimatedSprite2D

func update_face(face_sprite: AnimatedSprite2D) -> void:
	#var full_path = GameConstants.customer_sprites_path + face_name
	#var face = load(full_path)
	#print("Updating face")
	
	
	animated_customer_face = face_sprite
	animated_customer_face.global_position.x =  global_position.x + size.x/2
	animated_customer_face.global_position.y =  global_position.y + size.y/2
	animated_customer_face.play("default")
	animated_customer_face.visible = true

func start_dialog(dialog: Array):
	var midpoint = _get_mid_point()
	DialogueManager.start_dialog(midpoint, dialog)
	
func clear_face() -> void:
	animated_customer_face.visible = false
	animated_customer_face.stop()

func _get_mid_point() -> Vector2:
	var x = self.global_position.x + self.size.x/2
	var y = self.global_position.y
	var midpoint = Vector2(x,y)
	return midpoint


func _on_resized() -> void:
	animated_customer_face.position.x =  self.size.x/2
	animated_customer_face.position.y =  self.size.y/2
