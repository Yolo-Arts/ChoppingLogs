extends Interactable

@export var axe_upgrade_damage_amount: float = 5

func start_interaction() -> void:
	EventSystem.AXE_increase_axe_damage.emit(axe_upgrade_damage_amount)
