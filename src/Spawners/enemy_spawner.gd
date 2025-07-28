extends Node3D

@export var enemies: Array[PackedScene]
@export_range(0, 1) var spawn_chance: float

func _ready():
	var editorVisual = $EditorOnly
	editorVisual.queue_free()
	if enemies.size() == 0:
		push_warning("No enemies set")
	var rand = randf_range(0, 1)
	if rand < spawn_chance:
		var rand_index = randi_range(0, enemies.size()-1)
		var instance = enemies[rand_index].instantiate()
		add_child(instance)
