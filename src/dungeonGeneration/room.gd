extends Node

class_name Room

var room_id: int
var room_file: PackedScene
var is_dead_end: bool
var chunks: Array[Chunk] = []

func _init(_room_id: int, _room_file: PackedScene, _is_dead_end: bool, _chunks: Array[Chunk]) -> void:
	self.room_id = _room_id
	self.room_file = _room_file
	self.is_dead_end = _is_dead_end
	self.chunks = _chunks
