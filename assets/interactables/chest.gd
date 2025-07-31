extends Area3D

@onready var animation_player: AnimationPlayer = $chest/AnimationPlayer
var is_open = false

func _on_body_entered(body: Node3D) -> void:
	if body.name != "Player":
		return
	if is_open:
		return
	animation_player.play("opening")
	is_open = true
