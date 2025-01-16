extends Node

#func _ready() -> void:
	#DialogueSets = _load_dialogue_sets("res://Customers/customer_dialogue/ParentsWorkshop.json")
#
#var DialogueSets

enum Locations {
	ParentsWorkshop, ## Starting game location
	PersonalShop,
	University,
	AdventuresGuild,
	HighEndShop,
	TravellingShop,
	EliteScholars,
	Spy,
	AncientDecrypter,
	BlackMarket
}

const customer_class_path  = "res://Customers/customer_classes/"

const artifact_base_path = "res://Artifacts/Artifacts/"

const ArtifactPool: Dictionary = {
	Locations.ParentsWorkshop : [ # ParentsWorkshop
		"test_artifact.tres",
		"test_artifact2.tres",
		"test_artifact3.tres"
	]
}

const customer_sprites_path = "res://Customers/customer_sprites/"
const customer_scenes_path = "res://Customers/customer_scenes/"
# The strings give directories to the possible customer sprites, their dialogue and variance in stats

const CustomerPool: Dictionary = {
	Locations.ParentsWorkshop : [
		["sample_face1(32x32).png", "sample_body1(32x32).png", "dialogue_set1"],
		["sample_face2(32x32).png", "sample_body2(32x32).png", "dialogue_set2"],
		["sample_face3(32x32).png", "sample_body3(32x32).png", "dialogue_set3"],
		#["sample_face4(32x32).png", "sample_body4(32x32).png", "dialogue_set4"],
		#["sample_face5(32x32).png", "sample_body5(32x32).png", "dialogue_set5"]
	]
}

func _load_dialogue_sets(file_path: String):
	if FileAccess.file_exists(file_path):
		var data_file: FileAccess = FileAccess.open(file_path, FileAccess.READ)
		var parsed_result = JSON.parse_string(data_file.get_as_text())
		
		if parsed_result is Dictionary:
			return parsed_result
		else:
			print("Error reading file")
	else:
		print("Dialogue set file does not exist!")

func location_enum_to_string(location: int) -> String:
	match location:
		Locations.ParentsWorkshop:
			return "ParentsWorkshop"
		Locations.PersonalShop:
			return "PersonalShop"
		Locations.University:
			return "University"
		Locations.AdventuresGuild:
			return "AdventuresGuild"
		Locations.HighEndShop:
			return "HighEndShop"
		Locations.TravellingShop:
			return "TravellingShop"
		Locations.EliteScholars:
			return "EliteScholars"
		Locations.Spy:
			return "Spy"
		Locations.AncientDecrypter:
			return "AncientDecrypter"
		Locations.BlackMarket:
			return "BlackMarket"
		_:
			push_error("An Invalid location was attempted to be located")
			return "Unknown Location"

func bool_to_int(the_bool: bool) -> int:
	if the_bool:
		return 1
	else:
		return 0

func get_random_artifact(location: int) -> ArtifactData:
	var artifact_pool = ArtifactPool[location]
	var random_artifact =  artifact_pool[randi() % len(artifact_pool)]
	var artifact_path = artifact_base_path + random_artifact 
	var artifact: ArtifactData = load(artifact_path)
	return artifact
