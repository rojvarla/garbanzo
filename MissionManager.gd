extends Node

signal mission_updated(mission_id: String, status: String)
signal bridge_unlocked
signal tower_height_updated(height: float)
signal clock_path_unlocked
signal reading_town_unlocked

var missions = {
	"bridge_mission": {
		"name": "Puente del Abismo",
		"description": "Calcula la longitud de la viga diagonal para estabilizar el puente.",
		"status": "completed"
	},
	"tower_mission": {
		"name": "Torre del Sol",
		"description": "Calcula la altura de la torre.",
		"status": "completed"
	},
	"clock_mission": {
		"name": "El Reloj Solar",
		"description": "Calcula el ángulo de la sombra del reloj solar.",
		"status": "not_started",
		"pista": "Ángulo inicial: 45°"
	}
}

func _ready():
	# Forzar completado de misiones previas para pruebas (si ya las completaste)
	if missions["bridge_mission"]["status"] != "completed":
		complete_mission("bridge_mission")
	if missions["tower_mission"]["status"] != "completed":
		complete_mission("tower_mission")
	print("MissionManager initialized with mission states: ", missions)

func start_mission(mission_id: String):
	if mission_id in missions:
		missions[mission_id]["status"] = "in_progress"
		mission_updated.emit(mission_id, "in_progress")
		print("Mission started: ", mission_id)

func complete_mission(mission_id: String):
	if mission_id in missions:
		missions[mission_id]["status"] = "completed"
		mission_updated.emit(mission_id, "completed")
		if mission_id == "bridge_mission":
			bridge_unlocked.emit()
		elif mission_id == "tower_mission":
			tower_height_updated.emit(14.0)
		elif mission_id == "clock_mission":
			clock_path_unlocked.emit()
		print("Mission completed: ", mission_id)

func unlock_clock_path():
	clock_path_unlocked.emit()
	if all_missions_completed():
		reading_town_unlocked.emit()
	else:
		print("Cannot unlock ReadingTown yet")

func receive_pista(mission_id: String, pista: String):
	if mission_id in missions:
		missions[mission_id]["pista"] = pista
		print("Pista recibida para ", mission_id, ": ", pista)

func all_missions_completed():
	for mission in missions.values():
		if mission["status"] != "completed":
			print("Mission not completed: ", mission["name"], " - Status: ", mission["status"])
			return false
	print("All missions completed!")
	return true
		
