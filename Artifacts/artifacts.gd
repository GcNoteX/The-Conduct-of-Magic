class_name ArtifactData
extends Resource

@export_category("Artifact Information")
@export var name: String
@export var sprite_resource_path: String
@export var sprite: Texture2D

@export_category("Possible Class of Owners")
@export var class_owners: Array

@export_category("Artifact Runes")
@export var max_number_of_runes: int
@export var rune_table: Array # Or the number of runes runs out first

@export_category("Rune map")
# Will contain the runes, each index will contain the RuneStats(index 0) , its position (Vector2) (index 1)
@export var rune_map: Array[Array]

static func cast_data_to_artifact_instance(data: Dictionary) -> ArtifactData:
	# Load the Customer scene
	var artifact_instance = ArtifactData.new()
	
	artifact_instance.name = data["name"]
	artifact_instance.sprite_resource_path = data["sprite_resource_path"]
	#TODO Load the actual sprite
	artifact_instance.sprite = load(artifact_instance.sprite_resource_path)
	
	artifact_instance.class_owners = data["class_owners"]
	
	artifact_instance.max_number_of_runes = data["max_number_of_runes"]
	artifact_instance.rune_table = data["rune_table"]
	
	for rune_data_set in data["rune_map"]:
		var full_rune_path = RuneStats.runes_path + rune_data_set["rune_dir"] + ".tres"
		var rune_data = load(full_rune_path)
		
		var rune_positons = rune_data_set["position"]
		
		var position = Vector2(rune_positons[0], rune_positons[1])
		
		artifact_instance.rune_map.append([rune_data, position])
	
	return artifact_instance

static func cast_artifact_data_to_dict(artifact: ArtifactData) -> Dictionary:
	var content = {
		"name": artifact.name,
		"sprite_resource_path": artifact.sprite_resource_path,
		"class_owners": artifact.class_owners,
		"max_number_of_runes": artifact.max_number_of_runes,
		"rune_table": artifact.rune_table,
		"rune_map": cast_rune_map_to_array(artifact.rune_map)
	}
	
	return content

static func cast_rune_map_to_array(rune_map: Array) -> Array:
	var content = []	
	for rune_information in rune_map:
		var dict_instance = {}
		dict_instance["rune_dir"] = rune_information[0].rune_dir
		var position_info: Vector2 = rune_information[1]
		dict_instance["position"] = [position_info.x, position_info.y]
		
		content.append(dict_instance.duplicate())
		
	return content
