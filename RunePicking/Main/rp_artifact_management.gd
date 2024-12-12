class_name RPArtifactManager
extends Node

@export var commission_list: Array[CommissionData] = []

@onready var level_display: PackedScene = preload("res://RunePicking/Main/rp_level_display.tscn")

@onready var lab: RPLab = $Lab
@onready var bottom_ui: Control = $"Bottom UI"
@onready var combox1: RpCommissionList = $"Bottom UI/HBoxOfUI/RpCommissionList"
@onready var combox2: RpCommissionList = $"Bottom UI/HBoxOfUI/RpCommissionList2"
@onready var actions_display: RpActionsDisplay = $"Bottom UI/HBoxOfUI/RpActionsDisplay"

var instantiated_level: Node

signal ending_lab_session

func _enter_tree() -> void:
	if get_tree().current_scene == self:
		call_deferred("initialize_commission_list", commission_list)
	else:
		call_deferred("_update_displays")

func _ready() -> void:
	combox2.selected_commission_updated.connect(self._update_displays)
	actions_display.start_rune_picking.connect(self.start_rune_picking)
	actions_display.end_session.connect(self.end_lab_session)

func initialize_commission_list(new_commission_list: Array[CommissionData]) -> void:
	print("Commission list in the commission box, " , new_commission_list)
	commission_list = new_commission_list
	combox1.initialize_commission_list(commission_list)
	combox2.initialize_commission_list(commission_list)
	_update_displays()
	
func start_rune_picking() -> void:
	print("Start rune picking")
	# Get the artifact data from the commission data
	var artifact = _get_commission().artifact
	# Export the map from it and make a scene of it to do
	instantiated_level = level_display.instantiate()
	instantiated_level.rune_map = artifact.rune_map
	
	# Disable other nodes in the current scene.
	print("Disabling UI elements!")
	bottom_ui.visible = false
	lab.disable_collission_and_visibility()
	
	# Await.... On completion do x, on fail do y, on exit do z?
	get_tree().current_scene.add_child.call_deferred(instantiated_level)
	
	
	$TestRpDisplayGeneration.start()
	
	
	
func end_lab_session() -> void:
	print("Ending lab session")
	emit_signal("ending_lab_session")

# Function to update all display accept the commission list, updates everything based on the commission list selected commission
func _update_displays() -> void:
	# Update top display of lab scene
	_update_artifact_in_lab()
	
	# Update action buttons
	if len(commission_list) == 0:
		actions_display.disable_start_rune_picking_button()
	else:
		actions_display.enable_start_rune_picking_button()
	
func _update_artifact_in_lab() -> void:
	if !_commission_list_is_empty():
		print("Commission list NOT empty")
		var current_commission = _get_commission()
		lab.change_displayed_artifact(current_commission.artifact)
	else:
		print("Commission list empty")
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
	
	bottom_ui.visible = true
	lab.enable_collission_and_visibility()
