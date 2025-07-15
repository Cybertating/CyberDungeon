extends CharacterBody3D

@export var speed : float = 10
@export var maxStamina : float = 5
@export var speedGrowth : float = 0.5
@export var gravity : float = 1.5
@export var minimumRotationDistance : float = 0.1

@onready var camera : Camera3D = $Camera3D
@onready var model = $PlayerColision


var stamina = maxStamina
var currentSpeed = 1

var newVelocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	
	var movementDirection = Vector3.ZERO
	var sprintModifier = 1
	
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
	
	if Input.is_action_pressed("GoForward"):
		movementDirection.z -= 1
	if Input.is_action_pressed("GoBackward"):
		movementDirection.z += 1
	if Input.is_action_pressed("GoLeft"):
		movementDirection.x -= 1
	if Input.is_action_pressed("GoRight"):
		movementDirection.x += 1
		
	if Input.is_action_pressed("Sprint") and stamina > 0:
		sprintModifier = 1.3
	
	if movementDirection != Vector3.ZERO:
		movementDirection = movementDirection.normalized()
		currentSpeed += speedGrowth
		if currentSpeed > speed:
			currentSpeed = speed
	else:
		if currentSpeed > 1:
			currentSpeed -= 2 * speedGrowth
		if currentSpeed < 1:
			currentSpeed = 1
			
	if !is_on_floor():
		newVelocity.y -= gravity * delta
	
	newVelocity.x = movementDirection.x * currentSpeed * sprintModifier
	newVelocity.z = movementDirection.z * currentSpeed * sprintModifier
	
	velocity = newVelocity
	move_and_slide()
