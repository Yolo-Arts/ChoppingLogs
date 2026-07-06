extends Bulletin

@onready var black_overlay: TextureRect = $BlackOverlay
@onready var get_container: Control = %GetContainer
@onready var back_container: Control = %BackContainer
@onready var to_container: Control = %ToContainer
@onready var base_container: Control = %BaseContainer

func _ready() -> void:
	get_container.visible = true
	back_container.visible = false
	to_container.visible = false
	base_container.visible = false
	black_overlay.visible = true
	
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.MenuBtnPressed)
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(get_container, "scale", Vector2(0.9, 0.9), 0.4)
	tween.tween_callback(func(): 
		EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.MenuBtnPressed)
		get_container.visible = false
		back_container.visible = true
	)
	tween.tween_property(back_container, "scale", Vector2(0.9, 0.9), 0.4)
	tween.tween_callback(func(): 
		EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.MenuBtnPressed)
		back_container.visible = false
		to_container.visible = true
	)
	tween.tween_property(to_container, "scale", Vector2(0.9, 0.9), 0.4)
	tween.tween_callback(func(): 
		EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.MenuBtnPressed)
		to_container.visible = false
		base_container.visible = true
	)
	tween.tween_property(base_container, "scale", Vector2(0.9, 0.9), 0.4)
	tween.tween_callback(func(): 
		base_container.visible = false
		black_overlay.visible = false
		EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.BackToBase)
	)
