extends Control

@onready var angle_label = $Panel/Label_Angle

func _ready():
	visible = false
	size.x = 150
	size.y = 150
	modulate = Color(1, 1, 1, 1)
	z_index = 10
	print("CartographerMapClock initialized")

func show_map():
	visible = true
	print("Showing map at x=", position.x, ", y=", position.y)

func hide_map():
	visible = false

func update_angle(angle: float):
	angle_label.text = "C = " + str(angle) + "°"
	print("Map updated with angle: ", angle)
