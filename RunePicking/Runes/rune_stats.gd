class_name RuneStats
extends Resource

@export var rune_name: String
@export var rune_dir: String
@export var frames: SpriteFrames

@export var shape: Shape2D
@export var radius: int
@export var scale: int = 1
@export var stamina_recovered: float = 0

@export var awakened_sfx: AudioStream
@export var rune_modulate_color: Color = Color(1, 1, 1)  ## To differentiate between runes of same sprite

enum Rune_Type{
	BLANKRUNE
}

const runes_path: String = "res://RunePicking/Runes/rune_types/"
