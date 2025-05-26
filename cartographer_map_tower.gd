extends Control

@onready var height_label = $Panel/Label_Height

func _ready():
	visible = false
	size.x = 150
	size.y = 150
	modulate = Color(1, 1, 1, 1)
	z_index = 10
	print("CartographerMapTower initialized")

func show_map():
	visible = true
	print("Showing map at x=", position.x, ", y=", position.y)

func hide_map():
	visible = false

func update_height(height: float):
	height_label.text = "h = " + str(height) + " m"
	print("Map updated with height: ", height)
