class_name RPArtifactManager
extends Node

@onready var level_display: PackedScene = preload("res://RunePicking/Main/rp_level_display.tscn")

@onready var combox1: RpCommissionList = $"Bottom UI/HBoxOfUI/RpCommissionList"
@onready var combox2: RpCommissionList = $"Bottom UI/HBoxOfUI/RpCommissionList2"
@onready var actions_display: RpActionsDisplay = $"Bottom UI/HBoxOfUI/RpActionsDisplay"
@onready var lab: RPLab = $Lab

@export var commission_list: Array[CommissionData]
var instantiated_level: Node

func _ready() -> void:
	combox1.initialize_commission_list(commission_list)
	combox2.initialize_commission_list(commission_list)
	combox2.selected_commission_updated.connect(self._update_displays)
	actions_display.start_rune_picking.connect(self.start_rune_picking)
	actions_display.end_session.connect(self.end_lab_session)
	_update_artifact_in_lab()

func start_rune_picking() -> void:
	print("Start rune picking")
	# Get the artifact data from the commission data
	var artifact = _get_commission().artifact
	# Export the map from it and make a scene of it to do
	instantiated_level = level_display.instantiate()
	instantiated_level.rune_map = artifact.rune_map
	# Await.... On completion do x, on fail do y, on exit do z?
	get_tree().current_scene.add_child.call_deferred(instantiated_level)
	$TestRpDisplayGeneration.start()
	
	
	
func end_lab_session() -> void:
	print("Ending lab session")
	pass

# Function to update all display accept the commission list, updates everything based on the commission list selected commission
func _update_displays() -> void:
	print("Updating displays")
	# Update top display of lab scene
	_update_artifact_in_lab()
	
	# Update action buttons
	
func _update_artifact_in_lab() -> void:
	if !_commission_list_is_empty():
		var current_commission = _get_commission()
		lab.change_displayed_artifact(current_commission.artifact)
	else:
		lab.display_no_artifact()

func _remove_commission() -> void:
	if len(commission_list) > 0:
		commission_list.remove_at(combox2.get_commission_index())
		combox1.refresh_commission_list()
		combox2.refresh_commission_list()
		_update_displays()
	else:
		push_warning("Attempting to remove from a commission list which has no commissions")

func _commission_list_is_empty() -> bool:
	return len(commission_list) == 0

func _get_commission() -> CommissionData:
	return commission_list[combox2.get_commission_index()]
	
func _on_test_remove_button_pressed() -> void:
	_remove_commission()


func _on_test_rp_display_generation_timeout() -> void:
	instantiated_level.queue_free()
