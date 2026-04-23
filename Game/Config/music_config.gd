class_name MusicConfig

enum Keys {
	BGMPlaceHolder,
	BGMPlaceHolder2,
}

const FILE_PATHS := {
	Keys.BGMPlaceHolder: "res://Assets/Audio/Music/_investigation.wav",
	Keys.BGMPlaceHolder2: "res://Assets/Audio/Music/Three Red Hearts - Pixel War 1.ogg",
}

static func get_audio_stream(key:Keys) -> AudioStream:
	return load(FILE_PATHS.get(key))
