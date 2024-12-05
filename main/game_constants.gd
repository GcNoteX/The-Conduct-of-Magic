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
	Locations.ParentsWorkshop : [ # ParentsWorkshop
		"test_artifact.tres",
		"test_artifact2.tres"
	]
}

const customer_sprites_path = "res://Customers/customer_sprites/"

const FaceSpritePool: Dictionary = {
	Locations.ParentsWorkshop : [
		"sample_face1(32x32).png",
		"sample_face2(32x32).png",
		"sample_face3(32x32).png",
		"sample_face4(32x32).png",
		"sample_face5(32x32).png"
	]
}
