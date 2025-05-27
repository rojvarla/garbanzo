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
	if player == null:
		push_error("Player node not found in group 'player'. Ensure a Player node exists and is in the 'player' group.")
	print("Defensor de las Ideas initialized")

func _process(delta):
	if player_in_range and Input.is_action_just_pressed("interact") and not has_spoken:
		start_dialogue()

func _on_body_entered(body):
	if body == player:
		player_in_range = true
		$Label.visible = true
		$Label.text = "Presiona E para hablar"
		print("Player near Defensor de las Ideas")

func _on_body_exited(body):
	if body == player:
		player_in_range = false
		$Label.visible = false
		print("Player left Defensor de las Ideas")

func start_dialogue():
	if Dialogic.current_timeline != null:
		print("Another dialogue is active, skipping")
		return
	Dialogic.start("DefensorIdeas_Argument")
	Dialogic.timeline_ended.connect(_on_dialogue_ended, CONNECT_ONE_SHOT)
	has_spoken = true
	print("Starting DefensorIdeas_Argument dialogue")

func _on_dialogue_ended():
	print("DefensorIdeas_Argument dialogue ended")
