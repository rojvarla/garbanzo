extends Control

signal answer_submitted(answer: float)

@onready var label = $Panel/Label
@onready var line_edit = $Panel/LineEdit
@onready var submit_button = $Panel/SubmitButton
@onready var calculator_button = $Panel/CalculatorButton
@onready var calculator_panel = $Panel/CalculatorPanel

var calculator_visible = false
var current_input = ""

func _ready():
	visible = false
	modulate = Color(1, 1, 1, 1)
	z_index = 10
	size.x = 300
	size.y = 200
	if submit_button:
		submit_button.pressed.connect(_on_submit_pressed)
	if calculator_button:
		calculator_button.pressed.connect(_on_calculator_toggled)
	var button_names = [
		"Button_0", "Button_1", "Button_2", "Button_3", "Button_4",
		"Button_5", "Button_6", "Button_7", "Button_8", "Button_9",
		"Button_Dot", "Button_Cos", "Button_Equal"
	]
	for name in button_names:
		var button = calculator_panel.get_node_or_null(name)
		if button:
			if name == "Button_Cos":
				button.pressed.connect(_on_cos_pressed)
			elif name == "Button_Equal":
				button.pressed.connect(_on_equal_pressed)
			else:
				var digit = name.replace("Button_", "").replace("_", ".")
				button.pressed.connect(func(): _on_calculator_button(digit))
			if not button.text:
				button.text = name.replace("Button_", "").replace("_", ".")
		else:
			print("Error: Botón ", name, " no encontrado")
	print("RouteChallengeUI initialized")

func show_challenge(problem_text: String):
	label.text = problem_text
	visible = true
	line_edit.text = ""
	current_input = ""
	calculator_panel.visible = false
	calculator_visible = false
	print("Showing challenge: ", problem_text, " at x=", position.x, ", y=", position.y)

func _on_submit_pressed():
	var answer = line_edit.text.to_float()
	answer_submitted.emit(answer)
	visible = false
	print("Answer submitted: ", answer)

func _on_calculator_toggled():
	calculator_visible = !calculator_visible
	calculator_panel.visible = calculator_visible
	if calculator_visible:
		calculator_button.text = "Ocultar Calculadora"
	else:
		calculator_button.text = "Mostrar Calculadora"

func _on_calculator_button(digit: String):
	current_input += digit
	line_edit.text = current_input
	print("Calculator input: ", current_input)

func _on_cos_pressed():
	var angle = current_input.to_float()
	var cos_value = cos(deg_to_rad(angle))
	current_input = str(cos_value)
	line_edit.text = current_input
	print("Calculated cos(", angle, ") = ", cos_value)

func _on_equal_pressed():
	var expression = current_input
	if expression.is_valid_float():
		current_input = str(expression.to_float())
		line_edit.text = current_input
	else:
		current_input = ""
		line_edit.text = "Error"
	print("Calculator result: ", current_input)
