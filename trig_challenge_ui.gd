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
	submit_button.pressed.connect(_on_submit_pressed)
	calculator_button.pressed.connect(_on_calculator_toggled)
	$Panel/CalculatorPanel/Button_0.pressed.connect(func(): _on_calculator_button("0"))
	$Panel/CalculatorPanel/Button_1.pressed.connect(func(): _on_calculator_button("1"))
	$Panel/CalculatorPanel/Button_2.pressed.connect(func(): _on_calculator_button("2"))
	$Panel/CalculatorPanel/Button_3.pressed.connect(func(): _on_calculator_button("3"))
	$Panel/CalculatorPanel/Button_4.pressed.connect(func(): _on_calculator_button("4"))
	$Panel/CalculatorPanel/Button_5.pressed.connect(func(): _on_calculator_button("5"))
	$Panel/CalculatorPanel/Button_6.pressed.connect(func(): _on_calculator_button("6"))
	$Panel/CalculatorPanel/Button_7.pressed.connect(func(): _on_calculator_button("7"))
	$Panel/CalculatorPanel/Button_8.pressed.connect(func(): _on_calculator_button("8"))
	$Panel/CalculatorPanel/Button_9.pressed.connect(func(): _on_calculator_button("9"))
	$Panel/CalculatorPanel/Button_Dot.pressed.connect(func(): _on_calculator_button("."))
	$Panel/CalculatorPanel/Button_Tan.pressed.connect(_on_tan_pressed)
	$Panel/CalculatorPanel/Button_Equal.pressed.connect(_on_equal_pressed)
	$Panel/CalculatorPanel/Button_0.text = "0"
	$Panel/CalculatorPanel/Button_1.text = "1"
	$Panel/CalculatorPanel/Button_2.text = "2"
	$Panel/CalculatorPanel/Button_3.text = "3"
	$Panel/CalculatorPanel/Button_4.text = "4"
	$Panel/CalculatorPanel/Button_5.text = "5"
	$Panel/CalculatorPanel/Button_6.text = "6"
	$Panel/CalculatorPanel/Button_7.text = "7"
	$Panel/CalculatorPanel/Button_8.text = "8"
	$Panel/CalculatorPanel/Button_9.text = "9"
	$Panel/CalculatorPanel/Button_Dot.text = "."
	$Panel/CalculatorPanel/Button_Tan.text = "tan"
	$Panel/CalculatorPanel/Button_Equal.text = "="
	print("TrigChallengeUI initialized")

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

func _on_tan_pressed():
	var angle = current_input.to_float()
	var tan_value = tan(deg_to_rad(angle))
	current_input = str(tan_value)
	line_edit.text = current_input
	print("Calculated tan(", angle, ") = ", tan_value)

func _on_equal_pressed():
	var expression = current_input
	if expression.is_valid_float():
		current_input = str(expression.to_float())
		line_edit.text = current_input
	else:
		current_input = ""
		line_edit.text = "Error"
	print("Calculator result: ", current_input)
