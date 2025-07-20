extends Control

var player: Player
var health: Health

@onready var health_bar: TextureProgressBar = $HealthBar
@onready var health_label: Label = $HealthLabel

func _ready() -> void:
	player = get_parent().get_node("Player")
	assert(player, "Player not found in the tree. It should be a sibling of UI")
	
	health = player.get_node("Health")
	assert(health, "Player does not have the Health node")
	
	health.changed.connect(_on_health_changed)

func _on_health_changed(new_value: float, _by_who: Variant):
	health_bar.value = new_value
	health_label.text = str(int(new_value))
