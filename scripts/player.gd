extends CharacterBody2D

@export var speed: float = 100.0
@onready var animated_sprite = $AnimatedSprite2D
@export var inventario: inventario
var can_move = true

var last_direction = "front"  # Dirección inicial

func _ready():
	if Global.spawn_position:  # Si hay una posición guardada, úsala
		global_position = Global.spawn_position

func _process(_delta):
	if not can_move:
		velocity = Vector2.ZERO
		animated_sprite.stop()  # Opcional: detener la animación cuando no se mueve
		return

	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		direction.x += 1
		animated_sprite.play("walk_right")
		last_direction = "right"
	elif Input.is_action_pressed("ui_left"):
		direction.x -= 1
		animated_sprite.play("walk_left")
		last_direction = "left"
	elif Input.is_action_pressed("ui_down"):
		direction.y += 1
		animated_sprite.play("walk_front")
		last_direction = "front"
	elif Input.is_action_pressed("ui_up"):
		direction.y -= 1
		animated_sprite.play("walk_back")
		last_direction = "back"
	else:
		animated_sprite.play("idle_" + last_direction)

	velocity = direction.normalized() * speed
	move_and_slide()

func disable_movement():
	can_move = false
	print("Player movement disabled")

func enable_movement():
	can_move = true
	print("Player movement enabled")
