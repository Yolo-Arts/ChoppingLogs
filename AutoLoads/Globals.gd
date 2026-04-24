extends Node

var user_prefs: UserPrefs
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

# Note: If you change this, do not forget to change it in settomgs_menu.gd
var resolutions: Dictionary = {
	"3840x2160": Vector2i(3840, 2160),
	"2560x1440": Vector2i(2560, 1440),
	"1920x1080": Vector2i(1920, 1080),
	"1600x900": Vector2i(1600, 900),
	"1366x768": Vector2i(1366, 768),
	"1280x720": Vector2i(1280, 720),
	"1024x576": Vector2i(1024, 576),
	"640x360": Vector2i(640, 360)
}

func _ready() -> void:
	user_prefs = UserPrefs.load_or_create()
	
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(user_prefs.sfx_volume))
	AudioServer.set_bus_mute(SFX_BUS_ID, user_prefs.sfx_volume < .05)
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(user_prefs.music_volume))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, user_prefs.music_volume < .05)
	
	apply_resolution()

func apply_resolution() -> void:
	var res_str = user_prefs.resolution_str
	
	if resolutions.has(res_str):
		var target_size = resolutions[res_str]
		
		DisplayServer.window_set_size(target_size)
		var screen_id = DisplayServer.window_get_current_screen()
		var screen_size = DisplayServer.screen_get_size(screen_id)
		var window_pos = (screen_size / 2) - (target_size / 2)
		DisplayServer.window_set_position(window_pos)
	else:
		print("Resolution key not found: ", res_str)
