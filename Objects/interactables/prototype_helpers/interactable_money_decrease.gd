extends Interactable

func start_interaction() -> void:
	EventSystem.MON_decrease_money.emit(5)
