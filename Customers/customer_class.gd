class_name CustomerClass
extends Resource

@export var name_of_class: String
@export var possible_names: Array[String] = []


@export_category("Personality")
## How much they can pay the player for their job
@export_range(0, 10, 0.1) var min_richness: float
@export_range(0, 10, 0.1) var max_richness: float
## An added duration to how long it should take to solve the artifact before the customer comes back to receive
@export_range(0, 10, 1) var min_patience: int
@export_range(0, 10, 1) var max_patience: int
## Accuracy in determining the runes on a comissioned artifact
@export_range(0, 10, 1) var min_intelligence: int
@export_range(0, 10, 1) var max_intelligence: int


func get_class_sprite_set(artifact: String):
	var sprite_set: Array
	var all_sprites_and_dialogue: Dictionary = _get_sprites_and_dialogue()
	
	if !all_sprites_and_dialogue.has(artifact):
		push_error("This class does not have a set of sprites and dialogue for ", artifact)
	else:
		var sprites_and_dialogue = all_sprites_and_dialogue[artifact]
		
		var sprite_sets = sprites_and_dialogue["face_and_body_sprites"]
		sprite_set = sprite_sets[randi() % len(sprite_sets)]
		
		return sprite_set
	
func get_class_dialogue_set(artifact: String):
	var dialogue_set: Dictionary
	var all_sprites_and_dialogue: Dictionary = _get_sprites_and_dialogue()
	
	if !all_sprites_and_dialogue.has(artifact):
		push_error("This class does not have a set of sprites and dialogue for ", artifact)
	else:
		var sprites_and_dialogue = all_sprites_and_dialogue[artifact]
		
		var all_dialogues: Dictionary = sprites_and_dialogue["dialogue"]
		
		for dialogue_type in all_dialogues.keys():
			dialogue_set[dialogue_type] = all_dialogues[dialogue_type][randi() % len(all_dialogues[dialogue_type])]
	
		return dialogue_set
	
func get_class_commission_text_set(artifact: String):
	var commission_text_set: Dictionary
	var all_sprites_and_dialogue: Dictionary = _get_sprites_and_dialogue()
	
	if !all_sprites_and_dialogue.has(artifact):
		push_error("This class does not have a set of sprites and dialogue for ", artifact)
	else:
		var sprites_and_dialogue = all_sprites_and_dialogue[artifact]
		
		var all_commission_text: Dictionary = sprites_and_dialogue["commission"]
		
		for commission_text in all_commission_text.keys():
			commission_text_set[commission_text] = all_commission_text[commission_text][randi() % len(all_commission_text[commission_text])]
	
		return commission_text_set

func _get_sprites_and_dialogue():
	
	var file_path = GameConstants.customer_class_path + name_of_class + ".json"
	if FileAccess.file_exists(file_path):
		var data_file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		#data_file.close()
		
		if parsed_result is Dictionary:
			return parsed_result
		else:
			print("Error reading file")
	else:
		print("File does not exist!")
