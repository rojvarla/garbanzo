extends CharacterBody2D

var player_in_range = false
var has_spoken = false
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	$Label.visible = false
	animated_sprite.play("idle")
	# Ocultar al Anciano hasta que se complete la Misión 3
	visible = false
	get_node("/root/MissionManager").clock_path_unlocked.connect(_on_clock_path_unlocked)
	if player == null:
		push_error("Player node not found in group 'player'. Ensure a Player node exists and is in the 'player' group.")
	print("NPC_Elder initialized")

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not has_spoken:
		start_dialogue()

func _on_body_entered(body):
	if body == player:
		player_in_range = true
		$Label.visible = true
		print("Player near NPC_Elder")

func _on_body_exited(body):
	if body == player:
		player_in_range = false
		$Label.visible = false
		print("Player left NPC_Elder")

func _on_clock_path_unlocked():
	visible = true
	print("NPC_Elder revealed after Mission 3")

func start_dialogue():
	if Dialogic.current_timeline != null:
		print("Another dialogue is active, skipping")
		return
	Dialogic.start("Elder_Final")
	Dialogic.timeline_ended.connect(_on_dialogue_ended, CONNECT_ONE_SHOT)
	has_spoken = true
	print("Starting Elder_Final dialogue")

func _on_dialogue_ended():
	print("Elder_Final dialogue ended")
	get_node("/root/MissionManager").reading_town_unlocked.emit()  # Desbloquear ReadingTown al terminar el diálogo
