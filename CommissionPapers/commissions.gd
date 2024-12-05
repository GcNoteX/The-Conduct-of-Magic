class_name CommissionData
extends Resource

# Commissions are generated based on the customers stats, but they can also be custom made and attached to
# specific customers directly

@export var artifact: Artifact
@export var speculative_runes: String = ""## The guesswork on what runes are in the artifact
@export_multiline var artifact_description: String
@export_multiline var artifact_origin: String

@export var commission_due_date: int
@export var reward: float

func prepare_commission_data(customer: CustomerData, artifact_instance: Artifact):
	artifact = artifact_instance
	for rune in artifact_instance.runes:
		speculative_runes = rune.rune_name + "," + speculative_runes
	artifact_description = "This is a placeholder description of the artifact"
	artifact_origin = "This is a placeholder for the artifacts origin"
	
	commission_due_date = customer.patience
	reward = 10 * customer.richness
