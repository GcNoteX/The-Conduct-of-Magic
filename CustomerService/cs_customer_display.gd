class_name CustomerDisplay
extends PanelContainer

@onready var customer_face: TextureRect = $MarginContainer/CustomerFace

func _ready() -> void:
	pass

func update_face(face_name: String) -> void:
	var full_path = GameConstants.customer_sprites_path + face_name
	var face = load(full_path)
	customer_face.texture = face
	
func start_dialog(dialog: Array):
	var midpoint = _get_mid_point()
	DialogueManager.start_dialog(midpoint, dialog)
	
func clear_face() -> void:
	customer_face.texture = null

func _get_mid_point() -> Vector2:
	var x = self.global_position.x + self.size.x/2
	var y = self.global_position.y
	var midpoint = Vector2(x,y)
	return midpoint
