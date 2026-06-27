extends Interactable

func start_interaction() -> void:
	var end_day = EventSystem.QUO_check_quota.call()
	if end_day:
		EventSystem.QUO_increase_quota_amount.emit()
		EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.PlaceholderDayEnd)
	else:
		print("not enough money")
