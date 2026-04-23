extends Control

var main_tscn = "uid://cqguftua63irx"

func _ready() -> void:
	Globals.scene = "Menu"
	TransitionManager.play_fade_in_black()

func _on_play_btn_pressed() -> void:
	process_mode = PROCESS_MODE_DISABLED
	SoundManager.play_menuBtn()
	EventSystem.STA_change_stage.emit(StageConfig.Keys.Main)
	#TransitionManager.play_fade_in_black(true)
	#await TransitionManager.fade_in_black_animation_player.animation_finished
	#get_tree().change_scene_to_file(main_tscn)


func _on_options_btn_pressed() -> void:
	SoundManager.play_menuBtn()
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.SettingsMenu)

func _on_quit_btn_pressed() -> void:
	SoundManager.play_menuBtn()
	get_tree().quit()
