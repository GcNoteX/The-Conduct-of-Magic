class_name CommissionData
extends Resource

# Commissions are generated based on the customers stats, but they can also be custom made and attached to
# specific customers directly

@export var commissioner: String
@export var artifact: ArtifactData
@export var speculative_runes: String = "" ## The guesswork on what runes are in the artifact
@export_multiline var artifact_description: String
@export_multiline var artifact_origin: String

@export var commission_due_date: int
@export var reward: float

@export var is_completed: bool

static func cast_data_to_commission_instance(data: Dictionary) -> CommissionData:
	var commission_data_instance = CommissionData.new()
	
	commission_data_instance.commissioner = data["commissioner"]
	
	commission_data_instance.artifact = ArtifactData.cast_data_to_artifact_instance(data["commissioner"])
	
	commission_data_instance.speculative_runes = data["speculative_runes"]
	commission_data_instance.artifact_description = data["artifact_description"]
	commission_data_instance.artifact_origin = data["artifact_origin"]
	
	commission_data_instance.commission_due_date = int(data["commission_due_date"])
	commission_data_instance.reward = float(data["reward"])
	
	commission_data_instance.is_completed = bool(int(data["is_completed"]))
	
	return commission_data_instance


func prepare_commission_data(customer: Customer, customer_class: CustomerClass, artifact_instance: ArtifactData):
	commissioner = customer.customer_name
	artifact = artifact_instance
	
	for rune_name in artifact_instance.rune_table:
		speculative_runes = rune_name + "," + speculative_runes
		
	var commission_text: Dictionary = customer_class.get_class_commission_text_set(artifact_instance.name)
	artifact_description = commission_text["artifact_description"]
	artifact_origin = commission_text["artifact_origin"]
	
	commission_due_date = customer.patience
	reward = 10 * customer.richness


func _to_string() -> String:
	return "Commission - %s|%s (ID: %d)" % [commissioner, artifact.name, get_instance_id()]
