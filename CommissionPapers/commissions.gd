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
