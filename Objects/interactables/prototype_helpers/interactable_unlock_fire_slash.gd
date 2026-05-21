extends Interactable

func start_interaction() -> void:
	EventSystem.WEP_unlock_fire_slash.emit()
