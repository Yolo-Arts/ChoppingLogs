extends Interactable

func start_interaction() -> void:
	EventSystem.WEP_unlock_weapon.emit("AssaultRifle")
