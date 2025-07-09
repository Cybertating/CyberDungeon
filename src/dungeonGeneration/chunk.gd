extends Node

class_name Chunk

var location: Vector2i
var door_flags: int

func _init(_location: Vector2i, _door_flags: int = 0):
	self.location = _location
	self.door_flags = _door_flags
