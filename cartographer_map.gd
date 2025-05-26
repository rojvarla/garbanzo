extends Control

func _ready():
	visible = false
	size = Vector2(150, 150) # Tamaño para 640x360
	modulate = Color(1, 1, 1, 1)
	z_index = 10
	print("CartographerMap initialized")

func show_map():
	visible = true
	print("Showing map at position: ", position)

func hide_map():
	visible = false
