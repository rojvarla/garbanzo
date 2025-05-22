extends Control
signal opened
signal closed

var isOpen = false
@onready var inventario: inventario  = preload("res://inventario/inventario/inventaio/iteminventario/playerinventori.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()
func _ready():
	update()

func update():
	for i in range(min(inventario.items.size(), slots.size())):
		slots[i].update(inventario.items[i])
	

func open():
	visible = true
	isOpen = true

func close():
	visible = false
	isOpen = false
