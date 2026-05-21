extends Interactable
@export var damage_increase: float = 5

func start_interaction() -> void:
	EventSystem.UPG_increase_fire_slash_damage.emit(damage_increase)
