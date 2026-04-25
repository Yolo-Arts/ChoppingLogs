extends Interactable

func start_interaction() -> void:
	EventSystem.UPG_increase_inventory_size.emit()
