extends Object
class_name Util


static func load_rooms_from_json(path: String) -> Array[Room]:
	var file := FileAccess.open(path, FileAccess.READ)
	if not file:
		push_error("Failed to open file: %s" % path)
		return []

	var json_string := file.get_as_text()
	var rooms_data = JSON.parse_string(json_string)

	var rooms: Array[Room] = []
	for room_data in rooms_data:
		var room_id: int = room_data["id"]
		var room_file: PackedScene = load(room_data["roomFile"])
		var is_dead_end: bool = room_data["isDeadEnd"]
		
		var chunks: Array[Chunk] = []
		for chunk_data in room_data["chunks"]:
			var location_array: Array = chunk_data["location"]
			var location = Vector2i(location_array[0], location_array[1])
			var door_flags: int = chunk_data["doorFlags"]
			var chunk := Chunk.new(location, door_flags)
			chunks.append(chunk)

		var room := Room.new(room_id, room_file, is_dead_end, chunks)
		rooms.append(room)

	return rooms


static func rotate_vector2i(vec: Vector2i, degrees: int) -> Vector2i:
	match degrees % 360:
		0:
			return vec
		90:
			return Vector2i(vec.y, -vec.x)
		180:
			return Vector2i(-vec.x, -vec.y)
		270:
			return Vector2i(-vec.y, vec.x)
		_:
			push_error("Invalid rotation angle: %i" % degrees)
			return vec


static func rotate_flags(flags: int, degrees: int) -> int:
	degrees %= 360
	var shift: int = degrees / 90
	return ((flags >> shift) | (flags << (4 - shift))) & 0b1111
