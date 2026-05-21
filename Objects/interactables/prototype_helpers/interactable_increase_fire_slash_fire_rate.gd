extends Interactable
@export var fire_rate_increase: float = 5

func start_interaction() -> void:
	EventSystem.UPG_increase_fire_slash_fire_rate.emit(fire_rate_increase)
