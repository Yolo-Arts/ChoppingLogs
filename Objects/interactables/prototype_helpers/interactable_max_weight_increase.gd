extends Interactable

func start_interaction() -> void:
	EventSystem.UPG_increase_max_weight.emit()
