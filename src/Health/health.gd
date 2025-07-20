extends Node

class_name Health

## Signal emitted whenever the health value changes
signal changed(new_value: float, by_who: Variant)
## Signal emitted whenever a heal operation happened
signal healed(new_value: float, by_who: Variant)
## Signal emitted whenever a damage operation happened
signal damaged(new_value: float, by_who: Variant)
## Signal emitted when healed to [member max_health]
signal fully_healed(by_who: Variant)
## Signal emitted when health drops to 0
signal killed(by_who: Variant)

@export var default_health: float = 100.0
@export var max_health: float = 100.0
@export var can_be_healed: bool = true
@export var can_be_damaged: bool = true

## The current value of health
var value: float

@onready var parent: Node3D = get_parent()

func _ready() -> void:
	value = default_health
	parent.add_to_group(Group.HasHealth)

func heal(heal_value: float, by_who: Variant):
	if not can_be_healed:
		return
	
	value = clamp(value + heal_value, 0, max_health)
	
	changed.emit(value, by_who)
	healed.emit(value, by_who)
	
	if (value == max_health):
		fully_healed.emit(by_who)

func damage(damage_value: float, by_who: Variant):
	if not can_be_damaged:
		return
	value = clamp(value - damage_value, 0, max_health)
	
	changed.emit(value, by_who)
	damaged.emit(value, by_who)
	
	if (value == 0):
		killed.emit(by_who)
