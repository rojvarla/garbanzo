extends Control

signal answer_submitted(answer: float)

@onready var label = $Panel/Label
@onready var button_1 = $Panel/Button1
@onready var button_2 = $Panel/Button2
@onready var button_3 = $Panel/Button3

func _ready():
	button_1.text = "50 m"
	button_2.text = "48 m"
	button_3.text = "70 m"
	button_1.pressed.connect(_on_button_1_pressed)
	button_2.pressed.connect(_on_button_2_pressed)
	button_3.pressed.connect(_on_button_3_pressed)
	visible = false

func show_challenge(problem_text: String):
	label.text = problem_text
	visible = true

func _on_button_1_pressed():
	answer_submitted.emit(50.0)
	visible = false

func _on_button_2_pressed():
	answer_submitted.emit(48.0)
	visible = false

func _on_button_3_pressed():
	answer_submitted.emit(70.0)
	visible = false
