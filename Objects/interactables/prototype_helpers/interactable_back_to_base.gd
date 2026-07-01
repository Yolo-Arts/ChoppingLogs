extends Interactable

func start_interaction() -> void:
	var end_day = EventSystem.QUO_check_quota.call()
	if end_day:
		EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.ResultsScreen)
		EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.InteractionPrompt)
	else:
		print("not enough money")
