class_name CustomerDisplay
extends PanelContainer

@onready var customer_face: TextureRect = $MarginContainer/CustomerFace

func update_face(face_name: String) -> void:
	var full_path = GameConstants.customer_sprites_path + face_name
	var face = load(full_path)
	customer_face.texture = face
	
func start_dialog(dialog: Array):
	DialogueManager.start_dialog(self.global_position, dialog)
	
func clear_face() -> void:
	customer_face.texture = null
