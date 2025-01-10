class_name CommissionDisplay
extends PanelContainer

@onready var artifact_display: TextureRect = $HBoxContainer/LeftSide/VBoxContainer/ArtifactPanel/ArtifactDisplay
@onready var runes_display: RichTextLabel = $HBoxContainer/LeftSide/VBoxContainer/RunesPanel/RunesSpeculation
@onready var commission_description: RichTextLabel = $HBoxContainer/RightSide/VBoxContainer/DescriptionPanel/MarginContainer/CommissionDescription
@onready var origin_description: RichTextLabel = $HBoxContainer/RightSide/VBoxContainer/OriginPanel/MarginContainer/OriginDescription
@onready var time_display : RichTextLabel = $HBoxContainer/RightSide/VBoxContainer/CostTimePanel/CostTimeSeperator/Time
@onready var cost_display: RichTextLabel = $HBoxContainer/RightSide/VBoxContainer/CostTimePanel/CostTimeSeperator/Cost

func update_commission_display(commission: CommissionData) -> void:
	artifact_display.texture = commission.artifact.sprite
	print(commission.speculative_runes)
	runes_display.text = commission.speculative_runes
	commission_description.text = commission.artifact_description
	origin_description.text = commission.artifact_origin
	time_display.text = str(commission.commission_due_date)
	cost_display.text = str(commission.reward)
	
func clear_commission_display() -> void:
	artifact_display.texture = null
	runes_display.text = ""
	commission_description.text = ""
	origin_description.text = ""
	time_display.text = ""
	cost_display.text = ""
