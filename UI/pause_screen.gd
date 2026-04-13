extends CanvasLayer

@onready var resume_btn: Button = %ResumeBtn
@onready var options_btn: Button = %OptionsBtn
@onready var main_menu_btn: Button = %MainMenuBtn

func _ready() -> void:
	resume_btn.pressed.connect(_on_resume_btn_pressed)
	options_btn.pressed.connect(_on_options_btn_pressed)
	main_menu_btn.pressed.connect(_on_main_menu_btn_pressed)
	get_tree().paused = true

func _on_resume_btn_pressed() -> void:
	get_tree().paused = false
	SoundManager.play_normalBtn()
	queue_free()


func _on_options_btn_pressed() -> void:
	SoundManager.play_normalBtn()
	Globals.open_settings_menu()


func _on_main_menu_btn_pressed() -> void:
	get_tree().paused = false
	Engine.time_scale = 1.0
	SoundManager.play_menuBtn()
	get_tree().change_scene_to_file("res://UI/start_screen.tscn")
	queue_free()
