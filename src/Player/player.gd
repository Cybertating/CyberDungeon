extends CharacterBody3D

@export var speed = 10
@export var maxStamina = 5
var stamina = maxStamina

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
	
	newVelocity.x = movementDirection.x * speed * sprintModifier
	newVelocity.z = movementDirection.z * speed * sprintModifier
	
	velocity = newVelocity
	move_and_slide()
