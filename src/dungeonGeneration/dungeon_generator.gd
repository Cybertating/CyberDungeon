extends Node3D

const OPPOSITES := [2,3,0,1]
const CHUNK_SIZE := 10

func spawn_room(room: Room, room_location: Vector2i, rotation_angle: int):
	var instance = room.room_file.instantiate()
	instance.position = Vector3(room_location.x, 0, room_location.y)*CHUNK_SIZE
	instance.rotation = Vector3(0, deg_to_rad(rotation_angle), 0)
	add_child(instance)
	
	return instance


func check_availability(room: Room, room_position: Vector2i, dungeon_map: Dictionary) -> Array:
	var first_room: bool = dungeon_map.size() == 0
	var rotations = range(4)
	rotations.shuffle()
	
	for room_rotation in rotations:
		var rotation_angle = room_rotation*90
		for base_chunk in room.chunks:
			if base_chunk.door_flags == 0:
				continue
				
			var has_no_collisions: bool = true
			var doors_match: bool = false
			var new_spawn_locations: Array[Vector2i] = []
			var chunk_locations_and_flags: Array[Vector3i] = []
			
			for chunk in room.chunks:
				var current_chunk_location = Util.rotate_vector2i(chunk.location - base_chunk.location, rotation_angle) + room_position
				chunk_locations_and_flags.append(Vector3i(current_chunk_location.x, current_chunk_location.y, Util.rotate_flags(chunk.door_flags, rotation_angle)))
				
				if dungeon_map.has(current_chunk_location):
					has_no_collisions = false
					break
					
				for door_flag_bit in range(4):
					if (chunk.door_flags & (1 << door_flag_bit)) == 0:
						continue
					
					var relative_door_chunk_location = [Vector2i(0,-1), Vector2i(1,0), Vector2i(0,1), Vector2i(-1,0)][door_flag_bit]
					var door_chunk_location = current_chunk_location + Util.rotate_vector2i(relative_door_chunk_location, rotation_angle)
					
					if not dungeon_map.has(door_chunk_location):
						new_spawn_locations.append(door_chunk_location)
					elif dungeon_map[door_chunk_location] & Util.rotate_flags(1 << (OPPOSITES[door_flag_bit]), rotation_angle) > 0:
						doors_match = true
				
			if first_room or (has_no_collisions and doors_match):
				for location_and_flags in chunk_locations_and_flags:
					var chunk_location = Vector2i(location_and_flags.x, location_and_flags.y)
					dungeon_map[chunk_location] = location_and_flags.z
				return [rotation_angle, Util.rotate_vector2i(base_chunk.location, rotation_angle), new_spawn_locations]
	return []


func generate_dungeon(size: int, rooms: Array[Room]):
	var spawn_locations := [Vector2i(0,0)]
	var dungeon_map: Dictionary = {}
	var room_amount  := 0
	var opening_phase := true
	
	while spawn_locations.size() > 0:
		var index: int = randi() % spawn_locations.size()
		var roomPosition: Vector2i = spawn_locations[index]
		if dungeon_map.has(roomPosition):
			spawn_locations.remove_at(index)
			continue
			
		var shuffled_rooms = rooms.duplicate()
		shuffled_rooms.shuffle()
		for room in shuffled_rooms:
			if room.is_dead_end == opening_phase:
				continue
			
			var angle_position_spawns =  check_availability(room, roomPosition, dungeon_map)
			if angle_position_spawns == []:
				continue
			spawn_room(room, roomPosition-angle_position_spawns[1], angle_position_spawns[0])
			spawn_locations.remove_at(index)
			room_amount  += 1
			for chunk_position in angle_position_spawns[2]:
				spawn_locations.append(chunk_position)
			break
		if room_amount  == size:
			opening_phase = false


func _ready() -> void:
	var rooms = Util.load_rooms_from_json("res://assets/dungeonPlaceholders/rooms.json")
	generate_dungeon(100, rooms)
