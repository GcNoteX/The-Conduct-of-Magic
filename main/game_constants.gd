class_name GameConstants
extends Node

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
const GenericNames = [
	"Alice",
	"Bob",
	"Charlie",
	"Diana",
	"Edward",
	"Fiona",
	"George",
	"Hannah",
	"Isaac"
]

const artifact_path = "res://Artifacts/Artifacts/"

const ArtifactPool: Dictionary = {
	ParentWorkShop = [
		"test_artifact.tres",
		"test_artifact2.tres"
	]
}
