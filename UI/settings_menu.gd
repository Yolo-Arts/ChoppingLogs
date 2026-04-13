extends CanvasLayer
@onready var music_slider: HSlider = %MusicSlider
@onready var sfx_slider: HSlider = %SFXSlider
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")

var user_prefs: UserPrefs

func _ready() -> void:
	user_prefs = UserPrefs.load_or_create()
	
	if music_slider:
		music_slider.value = user_prefs.music_volume
	if sfx_slider:
		sfx_slider.value = user_prefs.sfx_volume

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		close_settings()


func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, value < .05)
	user_prefs.music_volume = value

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(value))
	AudioServer.set_bus_mute(SFX_BUS_ID, value < .05)
	user_prefs.sfx_volume = value
	SoundManager.play_uiSfxTest()

func _on_reset_defaults_btn_pressed() -> void:
	music_slider.value = 0.8
	sfx_slider.value = 0.8
	SoundManager.play_normalBtn()

func _on_close_btn_pressed() -> void:
	user_prefs.save()
	close_settings()

func close_settings():
	if music_slider:
		music_slider.value = user_prefs.music_volume
	if sfx_slider:
		sfx_slider.value = user_prefs.sfx_volume
	SoundManager.play_normalBtn()
	queue_free()

func _on_save_settings_btn_pressed() -> void:
	user_prefs.music_volume = music_slider.value
	user_prefs.sfx_volume = sfx_slider.value
	user_prefs.save()
