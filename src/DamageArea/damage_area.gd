extends Area3D

## The damage dealt to bodies in group HasHealth whenever they enter
## this damage area
@export var damage_dealt: float = 10.0
## The strength with which the damaged body is pushed back.
## Can be set to 0 to disable this feature.
@export var push_back_strength: float = 20.0
## The strength with which the damaged body is pushed up.
## Can be set to 0 to disable this feature.
@export var push_back_vertical_strength: float = 5.0

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group(Group.HasHealth):
		return
	var health: Health = body.get_node("Health")
	health.damage(damage_dealt, self)
	
	# Push the body away from the damage area
	body.push_back(push_back_strength, push_back_vertical_strength)
