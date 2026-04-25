extends Interactable

func start_interaction() -> void:
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.SellMenu)
