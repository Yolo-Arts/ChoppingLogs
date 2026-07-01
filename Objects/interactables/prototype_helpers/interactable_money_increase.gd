extends Interactable

@export var money: int = 500

func start_interaction() -> void:
	EventSystem.MON_add_money.emit(money)
