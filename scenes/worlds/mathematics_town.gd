extends Node2D

var is_animating = false

func _ready():
	var mission_manager = get_node("/root/MissionManager")
	mission_manager.bridge_unlocked.connect(_on_bridge_unlocked)
	mission_manager.tower_height_updated.connect(_on_tower_height_updated)
	mission_manager.clock_path_unlocked.connect(_on_clock_path_unlocked)
	mission_manager.reading_town_unlocked.connect(_on_reading_town_unlocked)
	$Bridge.visible = false
	$ClockPath.visible = false
	$NpcElder.visible = false
	$ExitDoor/Area2D.body_entered.connect(_on_exit_door_entered)
	$ExitDoor/Area2D.body_exited.connect(_on_exit_door_exited)
	$ExitDoor/Label.visible = false
	print("MathematicsTown initialized")

func _process(_delta):
	if is_animating:
		return
	if Input.is_action_just_pressed("ui_cancel"):  # Esc
		get_tree().change_scene_to_file("res://scenes/worlds/SpawnScene.tscn")
	if Input.is_action_just_pressed("ui_accept"):  # Espacio
		if $Player in $ExitDoor/Area2D.get_overlapping_bodies():
			start_door_animation()

func _on_bridge_unlocked():
	$Bridge.visible = true
	$Abyss/CollisionShape2D.disabled = true
	print("Bridge unlocked")

func _on_tower_height_updated(height: float):
	if $FinalTower:  # Cambiado de $Tower a $FinalTower
		$FinalTower.visible = true
	print("Tower height updated: ", height)

func _on_clock_path_unlocked():
	$ClockPath.visible = true
	$NpcElder.visible = true  # Asegura que el Anciano aparezca
	print("Clock path unlocked")

func _on_reading_town_unlocked():
	print("ReadingTown unlocked")

func _on_exit_door_entered(body):
	if body == $Player:
		$ExitDoor/Label.visible = true
		$ExitDoor/Label.text = "Presiona Espacio para regresar"
		print("Player near ExitDoor")

func _on_exit_door_exited(body):
	if body == $Player:
		$ExitDoor/Label.visible = false
		print("Player left ExitDoor")

func start_door_animation():
	is_animating = true
	$ExitDoor/AnimationPlayer.play("open_door")
	await $ExitDoor/AnimationPlayer.animation_finished
	get_tree().change_scene_to_file("res://scenes/worlds/SpawnScene.tscn")
	print("Returning to Spawn via ExitDoor")
	is_animating = false
