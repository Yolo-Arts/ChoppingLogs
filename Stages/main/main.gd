extends Node2D

func _ready() -> void:
	EventSystem.MUS_play_music.emit(MusicConfig.Keys.BGMPlaceHolder2)
