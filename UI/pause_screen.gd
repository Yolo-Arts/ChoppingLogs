extends Bulletin

@onready var resume_btn: Button = %ResumeBtn
@onready var options_btn: Button = %OptionsBtn
@onready var main_menu_btn: Button = %MainMenuBtn
@onready var continue_icon: TextureRect = %ContinueIcon
@onready var settings_icon: TextureRect = %SettingsIcon
@onready var exit_icon: TextureRect = %ExitIcon
@onready var paused_lbl: Label = %PausedLbl

func _ready() -> void:
	continue_icon.modulate.a = 0
	settings_icon.modulate.a = 0
	exit_icon.modulate.a = 0
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventSystem.HUD_hide_hud.emit()
	resume_btn.pressed.connect(_on_resume_btn_pressed)
	options_btn.pressed.connect(_on_options_btn_pressed)
	main_menu_btn.pressed.connect(_on_main_menu_btn_pressed)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(paused_lbl, "scale", Vector2(1.0, 1.0), 0.35).from(Vector2.ZERO)
	tween.parallel().tween_property(resume_btn, "scale", Vector2(1.0, 1.0), 0.35).from(Vector2.ZERO)
	tween.parallel().tween_property(options_btn, "scale", Vector2(1.0, 1.0), 0.35).from(Vector2.ZERO)
	tween.parallel().tween_property(main_menu_btn, "scale", Vector2(1.0, 1.0), 0.35).from(Vector2.ZERO)
	
	get_tree().paused = true

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu"):
		_on_resume_btn_pressed()
		get_viewport().set_input_as_handled()

func _on_resume_btn_pressed() -> void:
	get_tree().paused = false
	EventSystem.HUD_show_hud.emit()
	EventSystem.PLA_unfreeze_player.emit()
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.PauseMenu)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_options_btn_pressed() -> void:
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.SettingsMenu, true)
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.PauseMenu)


func _on_main_menu_btn_pressed() -> void:
	get_tree().paused = false
	Engine.time_scale = 1.0
	EventSystem.PLA_freeze_player.emit()
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.MenuBtnPressed)
	EventSystem.STA_change_stage.emit(StageConfig.Keys.MainMenu)
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.PauseMenu)
	

func _on_resume_btn_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(resume_btn, "scale", Vector2(1.1, 1.1), 0.1)
	continue_icon.modulate.a = 100
	settings_icon.modulate.a = 0
	exit_icon.modulate.a = 0


func _on_options_btn_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(options_btn, "scale", Vector2(1.1, 1.1), 0.1)
	continue_icon.modulate.a = 0
	settings_icon.modulate.a = 100
	exit_icon.modulate.a = 0


func _on_main_menu_btn_mouse_entered() -> void:
	var tween = create_tween()
	tween.tween_property(main_menu_btn, "scale", Vector2(1.1, 1.1), 0.1)
	continue_icon.modulate.a = 0
	settings_icon.modulate.a = 0
	exit_icon.modulate.a = 100


func _on_resume_btn_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(resume_btn, "scale", Vector2(1.0, 1.0), 0.1)
	continue_icon.modulate.a = 0

func _on_options_btn_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(options_btn, "scale", Vector2(1.0, 1.0), 0.1)
	settings_icon.modulate.a = 0

func _on_main_menu_btn_mouse_exited() -> void:
	var tween = create_tween()
	tween.tween_property(main_menu_btn, "scale", Vector2(1.0, 1.0), 0.1)
	exit_icon.modulate.a = 0
