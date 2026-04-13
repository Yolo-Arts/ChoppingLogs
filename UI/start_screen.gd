extends Control

var main_tscn = "uid://cqguftua63irx"


func _ready() -> void:
	Globals.scene = "Menu"
	TransitionManager.play_fade_in_black()

func _on_play_btn_pressed() -> void:
	process_mode = PROCESS_MODE_DISABLED
	SoundManager.play_menuBtn()
	TransitionManager.play_fade_in_black(true)
	await TransitionManager.animation_player.animation_finished
	get_tree().change_scene_to_file(main_tscn)


func _on_options_btn_pressed() -> void:
	SoundManager.play_menuBtn()
	Globals.open_settings_menu()

func _on_quit_btn_pressed() -> void:
	SoundManager.play_menuBtn()
	get_tree().quit()
