extends CharacterBody2D

var player_in_range = false
var has_spoken_once = false
var mission_completed = false
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animated_sprite = $AnimatedSprite2D
@onready var route_challenge_ui = preload("res://RouteChallengeUI.tscn").instantiate()
@onready var cartographer_map = preload("res://CartographerMapClock.tscn").instantiate()
@onready var sundial = get_parent().get_node_or_null("Sundial")  # Acceder al nodo hermano

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	$Label.visible = false
	animated_sprite.play("idle")
	var ui_layer = CanvasLayer.new()
	ui_layer.layer = 10
	get_tree().root.add_child(ui_layer)
	ui_layer.add_child(route_challenge_ui)
	ui_layer.add_child(cartographer_map)
	route_challenge_ui.answer_submitted.connect(_on_answer_submitted)
	get_node("/root/MissionManager").start_mission("clock_mission")
	if sundial == null:
		push_error("Sundial node not found in parent (MathematicsTown)")
	else:
		print("Sundial node found at: ", sundial.position)
	print("NPC_Clockmaker initialized")

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not mission_completed:
		start_dialogue()

func _on_body_entered(body):
	if body == $Player:
		player_in_range = true
		$Label.text = "Presiona E para hablar"
		$Label.visible = true
		print("Player entered interaction range")

func _on_body_exited(body):
	if body == $Player:
		player_in_range = false
		$Label.visible = false
		print("Player exited interaction range")

func start_dialogue():
	if Dialogic.current_timeline != null:
		print("Another dialogue is active, skipping")
		return
	var timeline_name = "Clockmaker_Initial_Dialogue" if not has_spoken_once else "Clockmaker_Repeat_Dialogue"
	Dialogic.start(timeline_name)
	Dialogic.timeline_ended.connect(_on_dialogue_ended, CONNECT_ONE_SHOT)
	has_spoken_once = true
	print("Starting dialogue: ", timeline_name)

func _on_dialogue_ended():
	if not mission_completed:
		route_challenge_ui.position.x = 170  # Personaliza
		route_challenge_ui.position.y = 80
		cartographer_map.position.x = 400
		cartographer_map.position.y = 100
		cartographer_map.show_map()
		route_challenge_ui.show_challenge("Calcula el ángulo de la sombra: base 5 m, poste 6 m, sombra 7 m.")
		print("Dialogue ended, showing UI at x=", route_challenge_ui.position.x, ", y=", route_challenge_ui.position.y, " and map at x=", cartographer_map.position.x, ", y=", cartographer_map.position.y)

func _on_answer_submitted(answer: float):
	cartographer_map.hide_map()
	if abs(answer - 78.5) < 1.0:
		mission_completed = true
		Dialogic.start("Clockmaker_Success")
		await Dialogic.timeline_ended  # Esperar a que termine Clockmaker_Success
		get_node("/root/MissionManager").complete_mission("clock_mission")
		get_node("/root/MissionManager").unlock_clock_path()
		if sundial != null:
			sundial.modulate = Color(1, 0.84, 0)  # Dorado
		else:
			print("Cannot change Sundial color: Sundial node is null")
		var all_completed = get_node("/root/MissionManager").all_missions_completed()
		print("All missions completed check: ", all_completed)
		if all_completed:
			print("Starting Elder_Final dialogue")
			Dialogic.start("Elder_Final")
		else:
			print("Not all missions completed yet")
		print("Correct answer, mission completed")
	else:
		Dialogic.start("Clockmaker_Failure")
		print("Incorrect answer: ", answer, " (expected 78.5)")
