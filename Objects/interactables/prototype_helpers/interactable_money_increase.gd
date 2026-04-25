extends Interactable

func start_interaction() -> void:
	EventSystem.MON_add_money.emit(5)
