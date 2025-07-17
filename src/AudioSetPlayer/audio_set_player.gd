extends Node

class_name AudioSetPlayer

@export var volume_db: float = 0.0
@export var sounds: Array[AudioStream] = []

@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

func _ready():
	audio_player.volume_db = volume_db

## Play one of the sounds from the set, chosen at random
func play(from_position: float = 0.0):
	if sounds.is_empty():
		push_warning("No sounds assigned.")
		return

	audio_player.stream = sounds[randi() % sounds.size()]
	audio_player.play(from_position)
