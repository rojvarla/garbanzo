extends CharacterBody2D

var player_in_range = false
var has_spoken_once = false
var mission_completed = false
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var math_challenge_ui = preload("res://MathChallengeUI.tscn").instantiate()

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	$Label.visible = false
	animated_sprite.play("idle")
	add_child(math_challenge_ui)
	math_challenge_ui.answer_submitted.connect(_on_answer_submitted)

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not mission_completed:
		start_dialogue()

func _on_body_entered(body):
	if body == player:
		player_in_range = true
		$Label.text = "Presiona E para hablar"
		$Label.visible = true

func _on_body_exited(body):
	if body == player:
		player_in_range = false
		$Label.visible = false

func start_dialogue():
	var timeline_name = "Architect_Initial_Dialogue" if not has_spoken_once else "Architect_Repeat_Dialogue"
	var dialogue = Dialogic.start(timeline_name)
	add_child(dialogue)
	dialogue.connect("timeline_ended", _on_dialogue_ended)
	has_spoken_once = true

func _on_dialogue_ended():
	if not mission_completed:
		math_challenge_ui.show_challenge("Calcula la distancia directa: 40 m a lo largo, 30 m hacia abajo.")

func _on_answer_submitted(answer: float):
	if abs(answer - 50.0) < 0.1: # Tolerancia para errores de redondeo
		mission_completed = true
		var dialogue = Dialogic.start("Architect_Success")
		add_child(dialogue)
		get_node("/root/MissionManager").complete_mission("bridge_mission")
	else:
		var dialogue = Dialogic.start("Architect_Failure")
		add_child(dialogue)
