extends Interactable

func start_interaction() -> void:
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.SellMenu)


func _on_log_sell_area_body_entered(body: Node3D) -> void:
	EventSystem.MON_sell_all_items.emit()
