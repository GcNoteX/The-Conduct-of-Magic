class_name ArtifactData
extends Resource

@export_category("Artifact Information")
@export var name: String
@export var sprite_id: String
@export var sprite: Texture2D

@export_category("Possible Class of Owners")
@export var class_owners: Array[String]

@export_category("Artifact Runes")
@export var max_number_of_runes: int
@export var rune_table: Array[String] # Or the number of runes runs out first

@export_category("Rune map")
# Will contain the runes, each index will contain the RuneStats(index 0) , its position (Vector2) (index 1)
@export var rune_map: Array[Array]

static func cast_data_to_artifact_instance(data: Dictionary) -> ArtifactData:
	# Load the Customer scene
	var artifact_instance = ArtifactData.new()
	
	artifact_instance.name = data["name"]
	artifact_instance.sprite_id = data["sprite_id"]
	#TODO Load the actual sprite
	
	artifact_instance.class_owners = data["class_owners"]
	
	artifact_instance.max_number_of_runes = int(data["max_number_of_runes"])
	artifact_instance.rune_table = data["rune_table"]
	
	for rune_data_set in data["rune_map"]:
		var rune_data = RuneStats.cast_data_to_rune_instance(rune_data_set["rune_stats"])
		
		var rune_positons = rune_data_set["position"]
		
		var position = Vector2(float(rune_positons[0]), float(rune_positons[1]))
		
		artifact_instance.rune_map.append([rune_data, position])
	
	return artifact_instance
