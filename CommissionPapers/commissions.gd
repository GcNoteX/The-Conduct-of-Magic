class_name CommissionData
extends Resource

# Commissions are generated based on the customers stats, but they can also be custom made and attached to
# specific customers directly

@export var artifact: Artifact
@export var speculative_runes: String ## The guesswork on what runes are in the artifact
@export_multiline var artifact_description: String
@export_multiline var artifact_origin: String

@export var commission_due_date: String
@export var reward: float
