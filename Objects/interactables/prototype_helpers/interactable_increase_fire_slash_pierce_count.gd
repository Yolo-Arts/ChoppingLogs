extends Interactable
@export var pierce_count_increase: float = 1

func start_interaction() -> void:
	EventSystem.UPG_increase_fire_slash_pierce_count.emit(pierce_count_increase)
