extends Interactable

@export var axe_upgrade_speed_amount: float = 0.02

func start_interaction() -> void:
	EventSystem.AXE_increase_axe_speed.emit(axe_upgrade_speed_amount)
