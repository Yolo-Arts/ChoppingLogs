extends Bulletin

@onready var zoom_content: Control = %ZoomContent

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventSystem.PLA_freeze_player.emit()
	EventSystem.HUD_hide_hud.emit()
	if zoom_content:
		_run_ripple_cascade(zoom_content, 0.0)

func _close_skill_tree() -> void:
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.SkillTree)
	EventSystem.PLA_unfreeze_player.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.HUD_show_hud.emit()

func _unhandled_key_input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu"):
		_close_skill_tree()

func _run_ripple_cascade(current_node: Node, current_delay: float) -> void:
	var next_delay = current_delay
	
	if current_node is SkillNode:
		if not current_node.visible:
			return 
			
		current_node.animate_pop_in(current_delay)
		next_delay += 0.12
		
	for child in current_node.get_children():
		_run_ripple_cascade(child, next_delay)
