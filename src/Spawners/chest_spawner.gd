extends Node3D

@export_range(0, 1) var spawn_chance: float
var chest = load("res://assets/interactables/chest.tscn")


func _ready():
	var editorVisual = $EditorOnly
	editorVisual.queue_free()
	var rand = randf_range(0, 1)
	if rand < spawn_chance:
		var instance = chest.instantiate()
		add_child(instance)
