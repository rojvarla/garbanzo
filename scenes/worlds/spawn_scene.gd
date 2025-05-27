extends Node2D

var reading_door_unlocked = false
var is_animating = false

func _ready():
	$MathDoor/Area2D.body_entered.connect(_on_math_door_entered)
	$MathDoor/Area2D.body_exited.connect(_on_math_door_exited)
	$ReadingDoor/Area2D.body_entered.connect(_on_reading_door_entered)
	$ReadingDoor/Area2D.body_exited.connect(_on_reading_door_exited)
	$MathDoor/Label.visible = false
	$ReadingDoor/Label.visible = false
	# Asegurarse de que las puertas comiencen cerradas
	$MathDoor/AnimatedSprite2D.animation = "default"
	$ReadingDoor/AnimatedSprite2D.animation = "default"
	get_node("/root/MissionManager").reading_town_unlocked.connect(_on_reading_town_unlocked)
	print("Spawn initialized")

func _process(_delta):
	if is_animating:
		return
	var math_door_bodies = $MathDoor/Area2D.get_overlapping_bodies()
	if math_door_bodies.size() > 0:
		print("Bodies overlapping MathDoor: ", math_door_bodies)
	else:
		print("No bodies overlapping MathDoor")
	if Input.is_action_just_pressed("ui_accept"):  # Espacio
		if $Player in $MathDoor/Area2D.get_overlapping_bodies():
			print("Player detected in MathDoor, starting transition")
			start_door_animation("math")
		elif $Player in $ReadingDoor/Area2D.get_overlapping_bodies() and reading_door_unlocked:
			print("Player detected in ReadingDoor, starting transition")
			start_door_animation("reading")
		else:
			print("Player not detected in any door")

func _on_math_door_entered(body):
	if body == $Player:
		$MathDoor/Label.visible = true
		$MathDoor/Label.text = "Presiona Espacio para entrar"
		print("Player near MathDoor")

func _on_math_door_exited(body):
	if body == $Player:
		$MathDoor/Label.visible = false
		print("Player left MathDoor")

func _on_reading_door_entered(body):
	if body == $Player:
		$ReadingDoor/Label.visible = true
		$ReadingDoor/Label.text = "Presiona Espacio para entrar" if reading_door_unlocked else "Bloqueado"
		print("Player near ReadingDoor")

func _on_reading_door_exited(body):
	if body == $Player:
		$ReadingDoor/Label.visible = false
		print("Player left ReadingDoor")

func start_door_animation(door_type: String):
	if is_animating:
		print("Transition already in progress, skipping")
		return
	is_animating = true
	# Deshabilitar el movimiento del Player
	if $Player.has_method("disable_movement"):
		$Player.disable_movement()
	# Cambiar directamente a la escena sin animación
	if door_type == "math":
		var error = get_tree().change_scene_to_file("res://scenes/worlds/MathematicsTown.tscn")
		if error != OK:
			print("Failed to change scene to MathematicsTown: ", error)
		else:
			print("Entering MathematicsTown")
	elif door_type == "reading":
		var error = get_tree().change_scene_to_file("res://scenes/worlds/ReadingTown.tscn")
		if error != OK:
			print("Failed to change scene to ReadingTown: ", error)
		else:
			print("Entering ReadingTown")
	# Habilitar el movimiento del Player (por si no cambia de escena)
	if $Player.has_method("enable_movement"):
		$Player.enable_movement()
	is_animating = false

func _on_reading_town_unlocked():
	reading_door_unlocked = true
	$ReadingDoor/AnimatedSprite2D.modulate = Color(0, 1, 0)  # Verde
	$ReadingDoor/Label.text = "Presiona Espacio para entrar"
	print("Reading door unlocked - reading_door_unlocked set to: ", reading_door_unlocked)
