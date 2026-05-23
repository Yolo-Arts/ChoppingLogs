extends Bulletin

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventSystem.PLA_freeze_player.emit()
	EventSystem.HUD_hide_hud.emit()

func _close_skill_tree() -> void:
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.SkillTree)
	EventSystem.PLA_unfreeze_player.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.HUD_show_hud.emit()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu"):
		_close_skill_tree()
