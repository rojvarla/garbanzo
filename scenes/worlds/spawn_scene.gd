extends Node2D

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
	# Eliminamos la conexión a reading_town_unlocked
	print("Spawn initialized")

func _process(_delta):
	if is_animating:
		return
	var player = get_tree().get_first_node_in_group("player")
	if not player:
		print("Player node not found in group 'player'")
		return
	var math_door_bodies = $MathDoor/Area2D.get_overlapping_bodies()
	if math_door_bodies.size() > 0:
		print("Bodies overlapping MathDoor: ", math_door_bodies)
	else:
		print("No bodies overlapping MathDoor - Player position: ", player.global_position, " MathDoor position: ", $MathDoor.global_position)
	var reading_door_bodies = $ReadingDoor/Area2D.get_overlapping_bodies()
	if reading_door_bodies.size() > 0:
		print("Bodies overlapping ReadingDoor: ", reading_door_bodies)
	else:
		print("No bodies overlapping ReadingDoor - Player position: ", player.global_position, " ReadingDoor position: ", $ReadingDoor.global_position)
	if Input.is_action_just_pressed("ui_accept"):  # Espacio
		if player in $MathDoor/Area2D.get_overlapping_bodies():
			print("Player detected in MathDoor, starting transition")
			start_door_animation("math")
		elif player in $ReadingDoor/Area2D.get_overlapping_bodies():
			print("Player detected in ReadingDoor, starting transition")
			start_door_animation("reading")
		else:
			print("Player not detected in any door - Player position: ", player.global_position)

func _on_math_door_entered(body):
	var player = get_tree().get_first_node_in_group("player")
	if body == player:
		$MathDoor/Label.visible = true
		$MathDoor/Label.text = "Presiona Espacio para entrar"
		print("Player near MathDoor")

func _on_math_door_exited(body):
	var player = get_tree().get_first_node_in_group("player")
	if body == player:
		$MathDoor/Label.visible = false
		print("Player left MathDoor")

func _on_reading_door_entered(body):
	var player = get_tree().get_first_node_in_group("player")
	if body == player:
		$ReadingDoor/Label.visible = true
		$ReadingDoor/Label.text = "Presiona Espacio para entrar"  # Siempre accesible
		print("Player near ReadingDoor")

func _on_reading_door_exited(body):
	var player = get_tree().get_first_node_in_group("player")
	if body == player:
		$ReadingDoor/Label.visible = false
		print("Player left ReadingDoor")

func start_door_animation(door_type: String):
	if is_animating:
		print("Transition already in progress, skipping")
		return
	is_animating = true
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("disable_movement"):
		player.disable_movement()
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
	if player and player.has_method("enable_movement"):
		player.enable_movement()
	is_animating = false

# Eliminamos _on_reading_town_unlocked() ya que no es necesario
