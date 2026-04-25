extends PlayerMenuBase

func _on_close_button_pressed() -> void:
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.SellMenu)
	EventSystem.PLA_unfreeze_player.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.HUD_show_hud.emit()
