class_name MusicConfig

enum Keys {
	BGMPlaceHolder,
	BGMPlaceHolder2,
	IslandAmbience,
}

const FILE_PATHS := {
	Keys.BGMPlaceHolder: "res://Assets/Audio/Music/_investigation.wav",
	Keys.BGMPlaceHolder2: "res://Assets/Audio/Music/Three Red Hearts - Pixel War 1.ogg",
	Keys.IslandAmbience: "res://Assets/Audio/Music/island_ambience.ogg"
}

static func get_audio_stream(key:Keys) -> AudioStream:
	return load(FILE_PATHS.get(key))
