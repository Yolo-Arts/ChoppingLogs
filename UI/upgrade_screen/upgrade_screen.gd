extends Bulletin
@onready var blur: ColorRect = %Blur
@onready var close_menu_button: TextureButton = $MarginContainer/CloseMenuButton
@onready var upgrades_container: PanelContainer = %UpgradesContainer
@onready var player_money_label: Label = %PlayerMoneyLabel

var player_money = EventSystem.MON_get_player_money.call()

var entrance_tween: Tween

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventSystem.PLA_freeze_player.emit()
	EventSystem.HUD_hide_hud.emit()
	get_tree().paused = true
	
	player_money_label.text = "$" + str(player_money)
	
	entrance_tween = create_tween()
	entrance_tween.set_trans(Tween.TRANS_BACK)
	entrance_tween.set_ease(Tween.EASE_OUT)
	entrance_tween.tween_property(upgrades_container, "position:y", 114, 1.0).from(-1500)

func menu_transition_out():
	if entrance_tween and entrance_tween.is_valid():
		entrance_tween.kill()
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(upgrades_container, "position:y", -1500, 0.5)
	tween.parallel().tween_property(blur, "modulate:a", 0.0, 0.5).from(1.0)
	tween.parallel().tween_property(close_menu_button, "modulate:a", 0.0, 0.5).from(1.0)
	tween.tween_callback(func(): 
		EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.UpgradeScreen)
		EventSystem.HUD_show_hud.emit()
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu"):
		close_menu()
		get_viewport().set_input_as_handled()

func _on_close_menu_button_pressed() -> void:
	close_menu()

func close_menu() -> void:
	EventSystem.PLA_unfreeze_player.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	#SaveManager.save_upgrades()
	get_tree().paused = false
	menu_transition_out()
