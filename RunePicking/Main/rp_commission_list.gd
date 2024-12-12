class_name RpCommissionList
extends PanelContainer

@onready var artifact_display: TextureRect = $HBoxContainer/LeftSide/VBoxContainer/ArtifactPanel/ArtifactDisplay
@onready var runes_display: RichTextLabel = $HBoxContainer/LeftSide/VBoxContainer/RunesPanel/RunesSpeculation
@onready var commission_description: RichTextLabel = $HBoxContainer/RightSide/VBoxContainer/DescriptionPanel/MarginContainer/CommissionDescription
@onready var origin_description: RichTextLabel = $HBoxContainer/RightSide/VBoxContainer/OriginPanel/MarginContainer/OriginDescription
@onready var time_display : RichTextLabel = $HBoxContainer/RightSide/VBoxContainer/CostTimePanel/CostTimeSeperator/Time
@onready var cost_display: RichTextLabel = $HBoxContainer/RightSide/VBoxContainer/CostTimePanel/CostTimeSeperator/Cost
@onready var back_button: Button = $MarginContainer1/LeftButton
@onready var next_button: Button = $MarginContainer2/RightButton

@export var commission_list: Array[CommissionData] = []
var commission_number: int = 0

signal selected_commission_updated

func _enter_tree() -> void:
	call_deferred("refresh_commission_list")

func initialize_commission_list(new_commission_list: Array[CommissionData]) -> void:
	commission_list = new_commission_list
	display_commission(0)

func _update_commission_display(commission: CommissionData) -> void:
	artifact_display.texture = commission.artifact.sprite
	runes_display.text = commission.speculative_runes
	commission_description.text = commission.artifact_description
	origin_description.text = commission.artifact_origin
	time_display.text = str(commission.commission_due_date)
	cost_display.text = str(commission.reward)
	
func display_no_commission() -> void:
	artifact_display.texture = null
	runes_display.text = "none"
	commission_description.text = "none"
	origin_description.text = "none"
	time_display.text = "none"
	cost_display.text = "none"

func display_commission(new_commission_number: int) -> void:
	back_button.disabled = false
	next_button.disabled = false
	
	if len(commission_list) == 0:
		display_no_commission()
		back_button.disabled = true
		next_button.disabled = true
		return
		
	# Only 1 element back and next disabled
	if len(commission_list) == 1:
		back_button.disabled = true
		next_button.disabled = true
	# Most left element -> left disabled, right if only 1 element
	elif new_commission_number == 0:
		back_button.disabled = true
	# Mose right element -> right disabled, left if only 1 element
	elif new_commission_number == len(commission_list) - 1:
		next_button.disabled = true
	# Element in between -> disabled neither
	else: 
		pass
		
	_update_commission_display(commission_list[commission_number])
	
func _on_left_button_pressed() -> void:
	commission_number -= 1
	display_commission(commission_number)
	emit_signal("selected_commission_updated")

func _on_right_button_pressed() -> void:
	commission_number += 1
	display_commission(commission_number)
	emit_signal("selected_commission_updated")

func get_commission_index() -> int:
	if len(commission_list) > 0:
		return commission_number
	else:
		push_warning("Commission indexes are being return without any commissions!")
		return -1

func refresh_commission_list() -> void:
	commission_number = 0
	display_commission(0)
