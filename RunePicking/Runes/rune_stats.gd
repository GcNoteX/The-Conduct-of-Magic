class_name RuneStats
extends Resource

@export var rune_name: String
@export var frames_id: String
@export var frames: SpriteFrames
@export var shape_id: String
@export var shape: Shape2D
@export var radius: int
@export var scale: int = 1
@export var stamina_recovered: float = 0
@export var awakened_sfx_path: String
@export var awakened_sfx: AudioStream
@export var rune_modulate_color: Color = Color(1, 1, 1)  ## To differentiate between runes of same sprite

enum Rune_Type{
	BLANKRUNE
}

static func cast_data_to_rune_instance(data: Dictionary) -> RuneStats:
	var rune_stats_instance = RuneStats.new()
	
	rune_stats_instance.rune_name = data["rune_name"]
	
	rune_stats_instance.frames_id = data["frames_id"]
	#TODO Get frames from frames_id data
	
	rune_stats_instance.shape_id = data["shape_id"]
	#TODO Get frames from shape_id data
	
	rune_stats_instance.radius = int(data["radius"])
	rune_stats_instance.scale = int(data["scale"])
	
	rune_stats_instance.stamina_recovered = float(data["stamina_recovered"])
	
	rune_stats_instance.awakened_sfx_path = data["awakened_sfx_id"]
	#TODO Get frames from awakened_sfx_path data
	
	rune_stats_instance.rune_modulate_color = Color(float(data["color"][0]),  float(data["color"][1]), float(data["color"][2]))
	
	return rune_stats_instance
