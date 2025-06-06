extends Node2D

# Variables
var player_in_range = false
var has_spoken_once = false
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	$Label.visible = false
	animated_sprite.play("idle")
	if player == null:
		push_error("Player node not found in group 'player'. Ensure a Player node exists and is in the 'player' group.")
	else:
		print("Player node found: ", player.name)
	print("NPC_Silvio initialized")

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact"):
		start_dialogue()

func _on_body_entered(body):
	if body == player:
		player_in_range = true
		$Label.text = "Presiona E para hablar"
		$Label.visible = true
		print("Player near NPC_Silvio")

func _on_body_exited(body):
	if body == player:  # Aseguro que use player, no $Player
		player_in_range = false
		$Label.visible = false
		print("Player left NPC_Silvio")

func start_dialogue():
	if Dialogic.current_timeline != null:
		print("Another dialogue is active, skipping")
		return
	var timeline_name = "Silvio_Initial_Dialogue" if not has_spoken_once else "Silvio_Repeat_Dialogue"
	Dialogic.start(timeline_name)
	Dialogic.timeline_ended.connect(_on_dialogue_ended, CONNECT_ONE_SHOT)
	has_spoken_once = true
	print("Starting dialogue: ", timeline_name)

func _on_dialogue_ended():
	print("Silvio dialogue ended")
