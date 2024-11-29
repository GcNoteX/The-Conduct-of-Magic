extends Node

var json = JSON.new()
var path = "user://data.json"

var data = {}

func save(content: Dictionary):
	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(json.stringify(content))
	file.close()
	file = null

func read_save():
	var file = FileAccess.open(path, FileAccess.READ)
	var content = json.parse_string(file.get_as_text())
	return content

func create_new_save_file():
	var file = FileAccess.open("res://Customers/customer_dialogue/ParentsWorkshop.json", FileAccess.READ)
	if file:
		var content = json.parse_string(file.get_as_text())
		data = content
		save(content)
	else:
		push_error("File directory to initialize new content has changed!!!")

func check_if_save_exists() -> bool:
	var file = FileAccess.open(path, FileAccess.READ)
	if file:
		file.close()  # Close the file if it exists
		print("FILE EXISTS!")
		return true    # File exists
	else:
		print("FILE DOES NOT EXISTS, MAKING NEW ONE")
		return false   # File doesn't exist
	
func _ready() -> void:
	if !check_if_save_exists():
		create_new_save_file()
	#print(read_save())
	
	
