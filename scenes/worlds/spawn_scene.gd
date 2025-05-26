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
	get_node("/root/MissionManager").reading_town_unlocked.connect(_on_reading_town_unlocked)
	print("Spawn initialized")

func _process(_delta):
	if is_animating:
		return
	if Input.is_action_just_pressed("ui_accept"):  # Espacio
		if $Player in $MathDoor/Area2D.get_overlapping_bodies():
			start_door_animation("math")
		elif $Player in $ReadingDoor/Area2D.get_overlapping_bodies() and reading_door_unlocked:
			start_door_animation("reading")

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
	is_animating = true
	if door_type == "math":
		$MathDoor/AnimationPlayer.play("open_door")
		await $MathDoor/AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://scenes/worlds/MathematicsTown.tscn")
		print("Entering MathematicsTown")
	elif door_type == "reading":
		$ReadingDoor/AnimationPlayer.play("open_door")
		await $ReadingDoor/AnimationPlayer.animation_finished
		get_tree().change_scene_to_file("res://scenes/worlds/ReadingTown.tscn")
		print("Entering ReadingTown")
	is_animating = false

func _on_reading_town_unlocked():
	reading_door_unlocked = true
	$ReadingDoor/AnimatedSprite2D.modulate = Color(0, 1, 0)  # Verde
	$ReadingDoor/Label.text = "Presiona Espacio para entrar"
	print("Reading door unlocked")
