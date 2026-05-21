extends Interactable

@export var axe_range_increase: float = 1

func start_interaction() -> void:
	EventSystem.UPG_increase_axe_range.emit(axe_range_increase)
