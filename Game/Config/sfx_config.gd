class_name SFXConfig

enum Keys {
	MenuBtnPressed,
	NormalButtonPressed,
	UISFXTest,
}

const FILE_PATHS := {
	Keys.MenuBtnPressed: "res://Assets/Audio/SFX_Resources/MenuBtnPressedRandomizer.tres",
	Keys.NormalButtonPressed: "res://Assets/Audio/SFX_Resources/NormalButtonRandomizer.tres",
	Keys.UISFXTest: "res://Assets/Audio/UIBtnSFX/RetroBtnSFX/Retro10.mp3",
}

static func get_audio_stream(key:Keys) -> AudioStream:
	return load(FILE_PATHS.get(key))
