extends Node

var settings_menu = null
var settings_menu_scene: PackedScene = preload("res://UI/settings_menu.tscn")
var pause_menu = null
var pause_menu_scene: PackedScene = preload("res://UI/pause_screen.tscn")

@export_enum("Menu", "LevelOne", "LevelTwo", "Endless") var scene: String = "Menu"

var user_prefs: UserPrefs
@onready var SFX_BUS_ID = AudioServer.get_bus_index("SFX")
@onready var MUSIC_BUS_ID = AudioServer.get_bus_index("Music")

func _ready() -> void:
	user_prefs = UserPrefs.load_or_create()
	SoundManager.play_bgmPlaceholder()
	
	AudioServer.set_bus_volume_db(SFX_BUS_ID, linear_to_db(user_prefs.sfx_volume))
	AudioServer.set_bus_mute(SFX_BUS_ID, user_prefs.sfx_volume < .05)
	AudioServer.set_bus_volume_db(MUSIC_BUS_ID, linear_to_db(user_prefs.music_volume))
	AudioServer.set_bus_mute(MUSIC_BUS_ID, user_prefs.music_volume < .05)

func open_settings_menu():
	if not settings_menu:
		settings_menu = settings_menu_scene.instantiate()
		get_tree().root.add_child(settings_menu)
	else:
		push_warning("settings menu already exists in this scene")

func open_pause_menu():
	if not pause_menu:
		pause_menu = pause_menu_scene.instantiate()
		get_tree().root.add_child(pause_menu)
	else:
		push_warning("pause menu already exists in this scene")
