extends Interactable
@export var radius_increase_amount: float = 0.5

func start_interaction() -> void:
	EventSystem.UPG_increase_sell_radius.emit(radius_increase_amount)
