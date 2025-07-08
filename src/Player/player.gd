extends CharacterBody3D

@export var speed = 10
@export var maxStamina = 5
@export var speedGrowth = 0.5
var stamina = maxStamina
var currentSpeed = 1

var newVelocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	var movementDirection = Vector3.ZERO
	var sprintModifier = 1
	
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
	
	newVelocity.x = movementDirection.x * currentSpeed * sprintModifier
	newVelocity.z = movementDirection.z * currentSpeed * sprintModifier
	
	velocity = newVelocity
	move_and_slide()
