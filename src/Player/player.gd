extends CharacterBody3D

class_name Player

@export var speed: float = 7.0
@export var sprint_multiplier: float = 1.8
@export var acceleration: float = 30.0
@export var deceleration: float = 60.0
@export var jump_velocity: float = 7.0
@export var gravity: float = 35.0
@export var minimumRotationDistance : float = 0.1

@onready var camera : Camera3D = $Camera3D
@onready var model = $PlayerColision
@onready var damaged_audio_player: AudioSetPlayer = $DamagedAudioPlayer

var currentSpeed = 1

var external_velocity := Vector3.ZERO

## Apply a force to the Player
func apply_impulse(impulse: Vector3):
	external_velocity += impulse

## Push the player back (relative to their current velocity)
## Can also accept vercical_strength to additionaly launch
## the player upward (the direction is independent of player's velocity)
func push_back(strength: float, vertical_strength: float = 0.0):
	var direction = velocity
	direction.y = 0
	direction = direction.normalized()
	direction.y = 1
	external_velocity = direction * Vector3(-strength, vertical_strength, -strength)

func _get_input_direction() -> Vector3:
	var direction = Vector3.ZERO
	if Input.is_action_pressed("GoForward"):
		direction.x -= 1.0
		direction.z -= 1.0
	if Input.is_action_pressed("GoBackward"):
		direction.z += 1.0
		direction.x += 1.0
	if Input.is_action_pressed("GoLeft"):
		direction.x -= 1.0
		direction.z += 1.0
	if Input.is_action_pressed("GoRight"):
		direction.x += 1.0
		direction.z -= 1.0
	return direction.normalized()

func _physics_process(delta: float) -> void:
	var mousePosition = get_viewport().get_mouse_position()
	var rayLength = 10000
	var rayStart = camera.project_ray_origin(mousePosition)
	var rayTarget = rayStart + camera.project_ray_normal(mousePosition) * rayLength
	var spaceState = get_world_3d().direct_space_state
	var rayQuery = PhysicsRayQueryParameters3D.new()
	rayQuery.from = rayStart
	rayQuery.to = rayTarget
	var rayQueryResult = spaceState.intersect_ray(rayQuery)
	var lookVector = rayQueryResult.get("position")
	if lookVector != null:
		lookVector.y = position.y + 1
		
		#alternative rotation fix (causes problems with rotation towards camera) may be better if improved
		#if abs(position.x - lookVector.x) < minimumRotationDistance:
		#	lookVector.x += sign(lookVector.x) * minimumRotationDistance
		#if abs(position.z - lookVector.z) < minimumRotationDistance:
		#	lookVector.z += sign(lookVector.z) * minimumRotationDistance
		#model.look_at(lookVector)
		
		#print_debug(lookVector)
		
		#current rotation fix, disables rotation when mouse is to close to player
		if abs(position.x - lookVector.x) > minimumRotationDistance and abs(position.z - lookVector.z) > minimumRotationDistance:
			model.look_at(lookVector)
	
	var direction = _get_input_direction()
	var is_sprinting = Input.is_action_pressed("Sprint")
	var target_speed = speed * (sprint_multiplier if is_sprinting else 1.0)
	var target_velocity = direction * target_speed
	
	var velocity_difference = target_velocity - velocity
	var max_speed_change = (acceleration * delta) if velocity_difference.length() > 0 else deceleration * delta
	velocity.x += clamp(velocity_difference.x, -max_speed_change, max_speed_change)
	velocity.z += clamp(velocity_difference.z, -max_speed_change, max_speed_change)
	
	# Handle gravity and jumping
	if not is_on_floor():
		velocity.y -= gravity * delta
	else:
		if Input.is_action_pressed("Jump"):
			velocity.y = jump_velocity
		else:
			velocity.y = 0
	
	# Handle external forces
	if not external_velocity.is_zero_approx():
		velocity += external_velocity
		external_velocity = Vector3.ZERO
	
	move_and_slide()

func _on_damaged(_new_value: float, _by_who: Variant) -> void:
	damaged_audio_player.play()
