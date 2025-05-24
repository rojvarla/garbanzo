extends CharacterBody2D

# Variables
var player_in_range = false
var has_spoken_once = false
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animated_sprite = $AnimatedSprite2D

func _ready():
	# Conectar señales del Area2D
	$Area2D.body_entered.connect(_on_body_entered)
	$Area2D.body_exited.connect(_on_body_exited)
	$Label.visible = false
	# Reproducir la animación idle
	animated_sprite.play("idle")

func _process(delta):
	# Activar diálogo con la tecla "E"
	if player_in_range and Input.is_action_just_pressed("interact"):
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
	# Iniciar la Timeline de Dialogic
	var timeline_name = "Guide_Initial_Dialogue" if not has_spoken_once else "Guide_Repeat_Dialogue"
	var dialogue = Dialogic.start(timeline_name)
	add_child(dialogue)
	has_spoken_once = true
