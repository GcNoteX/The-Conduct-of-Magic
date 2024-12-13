class_name RPArtifactManager
extends Node

@export var full_commission_list: Array[CommissionData] = []
@export var commission_list: Array[CommissionData] = []

@onready var level_display: PackedScene = preload("res://RunePicking/Main/rp_level_display.tscn")

@onready var lab: RPLab = $Lab
@onready var bottom_ui: Control = $"Bottom UI"
@onready var combox1: RpCommissionList = $"Bottom UI/HBoxOfUI/RpCommissionList"
@onready var combox2: RpCommissionList = $"Bottom UI/HBoxOfUI/RpCommissionList2"
@onready var actions_display: RpActionsDisplay = $"Bottom UI/HBoxOfUI/RpActionsDisplay"

var instantiated_level: RpLevelDisplay

signal ending_lab_session

func _enter_tree() -> void:
	
	if get_tree().current_scene == self:
		call_deferred("initialize_commission_list", full_commission_list)
	else:
		pass
		#call_deferred("_update_displays")

func _ready() -> void:
	combox2.selected_commission_updated.connect(self._update_displays)
	actions_display.start_rune_picking.connect(self.start_rune_picking)
	actions_display.end_session.connect(self.end_lab_session)

func initialize_commission_list(new_commission_list: Array[CommissionData]) -> void:
	full_commission_list = new_commission_list
	for commission in full_commission_list:
		if !commission.is_completed:
			commission_list.append(commission) 
			
	print("Full Commission list, " , full_commission_list)
	print("None completed Commission list, " , commission_list)

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
	instantiated_level.exit_level_display.connect(_rune_map_exited)
	
	# Hide other nodes in the current scene.
	bottom_ui.visible = false
	lab.disable_collission_and_visibility()
	
	# Await.... On completion do x, on fail do y, on exit do z?
	get_tree().current_scene.add_child.call_deferred(instantiated_level)
	
	await instantiated_level.exit_level_display # Just to pause
	
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

func _rune_map_exited(is_completed: bool) -> void:
	if is_completed:
		var commission = _get_commission()
		commission.is_completed = true
		_refresh_available_commissions()
		
	instantiated_level.queue_free()
	
	bottom_ui.visible = true
	lab.enable_collission_and_visibility()
	
func _refresh_available_commissions() -> void:
	_remove_commission()
