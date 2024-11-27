extends Node2D

var wall_area: Rect2 = Rect2(Vector2(0,0), Vector2(1,1))

func _ready() -> void:
	var collision_shape_size = $Area2D/CollisionShape2D.shape.size as Vector2
	var current_pos = $Area2D.global_position
	var left_corner = current_pos - collision_shape_size/2
	wall_area = Rect2(left_corner, collision_shape_size) as Rect2
	
	var color_rect = $ColorRect as ColorRect
	# Set the ColorRect to match the Rect2
	color_rect.size = collision_shape_size # Set the position of the ColorRect
	color_rect.position = left_corner  # Set the size of the ColorRect
	color_rect.color = Color(1, 0, 0, 0.5)  # Set color (e.g., semi-transparent red)

	
func _process(delta):
	
	var mouse_pos = get_global_mouse_position()
	var wall_center = wall_area.get_center()
	var wall_size = wall_area.size
	var new_pos = mouse_pos
	# If mouse enters restricted area, move it to the nearest edge
	if wall_area.has_point(mouse_pos):
		if mouse_pos.x < wall_center.x and mouse_pos.y < wall_center.y:
			new_pos.x = mouse_pos.x - (wall_size.x/2 - abs(wall_center.x - mouse_pos.x))
			#new_pos.y = mouse_pos.y - (wall_size.y/2 - abs(wall_center.y - mouse_pos.y))
	
		elif mouse_pos.x >=  wall_center.x and mouse_pos.y < wall_center.y:
			new_pos.x = mouse_pos.x + (wall_size.x/2 - abs(wall_center.x - mouse_pos.x))
			#new_pos.y = mouse_pos.y - (wall_size.y/2 - abs(wall_center.y - mouse_pos.y))

		elif  mouse_pos.x < wall_center.x and mouse_pos.y >=  wall_center.y:
			#new_pos.x = mouse_pos.x - (wall_size.x/2 - abs(wall_center.x - mouse_pos.x))
			new_pos.y = mouse_pos.y + (wall_size.y/2 - abs(wall_center.y - mouse_pos.y))
			
		else:
			#new_pos.x = mouse_pos.x + (wall_size.x/2 - abs(wall_center.x - mouse_pos.x))
			new_pos.y = mouse_pos.y + (wall_size.y/2 - abs(wall_center.y - mouse_pos.y))

		Input.warp_mouse(new_pos)

	else:
		#Input.warp_mouse(get_global_mouse_position() + Vector2(1,1))
		print("false")
		
	print("Mouse ", get_global_mouse_position())
	print("wall_center ", wall_center)
	print(wall_size)
