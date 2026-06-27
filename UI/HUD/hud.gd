extends Control

@onready var money_label: Label = %MoneyLabel
@onready var trees_remaining_label: Label = %TreesRemainingLabel
@onready var time_label: Label = %TimeLabel
@onready var quota_amount: Label = %QuotaAmount


func _ready() -> void:
	EventSystem.HUD_reset_hud_elements.connect(reset_hud_elements)
	EventSystem.MON_money_updated.connect(update_text)
	EventSystem.MON_cannot_decrease_money.connect(func():
		update_text(EventSystem.MON_get_player_money.call(), Color.RED)
	)
	
	EventSystem.TRE_tree_spawned.connect(update_tree_text)
	EventSystem.TRE_tree_cut.connect(check_if_game_won)
	EventSystem.HUD_update_time.connect(_on_time_updated)
	EventSystem.QUO_update_quota_text.connect(update_quota_text)

func reset_hud_elements():
	money_label.text = "$" + str(0.0)

func update_text(money: float, color: Color):
	money_label.text = "$" + str(money)
	apply_text_effect(money_label, color)

func update_quota_text() -> void:
	quota_amount.text = "Quota: $" + str(EventSystem.QUO_get_quota_amount.call())

func apply_text_effect(label: Label, color: Color):
	var tween = create_tween().set_parallel(true)
	
	var color_chain = create_tween()
	color_chain.tween_property(label, "theme_override_colors/font_color", color, 0.1)

		
	color_chain.tween_property(label, "theme_override_colors/font_color", Color.WHITE, 0.3).set_delay(0.1)
	
	tween.tween_property(label, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.2).set_delay(0.1)

# TODO change it so that update_tree_text is not called everytime a tree is spawned
func update_tree_text(tree_count: int = 0):
	await get_tree().process_frame
	var trees_in_scene: int = 0
	if tree_count:
		trees_in_scene = tree_count
	else:
		trees_in_scene = get_tree().get_nodes_in_group("Trees").size()
		
	trees_remaining_label.text = "Trees Remaining: " + str(trees_in_scene)
	apply_text_effect(trees_remaining_label, Color.YELLOW)
	

func check_if_game_won():
	await get_tree().process_frame
	var tree_count = get_tree().get_nodes_in_group("Trees").size()
	if tree_count < 1:
		print("You Win!")
		EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.WinScreen)
	else:
		update_tree_text(tree_count)

var _time_pop_tween: Tween
var _last_seconds_left: int = -1

func _on_time_updated(new_time: String, seconds_left: int) -> void:
	time_label.text = new_time

	var target_color: Color = Color.WHITE
	var target_scale: Vector2 = Vector2.ONE

	if seconds_left <= 10:
		target_color = Color.RED
		target_scale = Vector2(1.3, 1.3)
	elif seconds_left <= 30:
		target_color = Color.ORANGE
		target_scale = Vector2(1.15, 1.15)

	time_label.modulate = target_color

	if seconds_left != _last_seconds_left:
		_last_seconds_left = seconds_left

		if seconds_left <= 30:
			time_label.pivot_offset = time_label.size / 2

			if _time_pop_tween and _time_pop_tween.is_valid():
				_time_pop_tween.kill()

			_time_pop_tween = create_tween().set_parallel(true)
			_time_pop_tween.tween_property(time_label, "scale", target_scale * 1.2, 0.05)\
				.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
			_time_pop_tween.chain().tween_property(time_label, "scale", target_scale, 0.15)\
				.set_trans(Tween.TRANS_ELASTIC).set_ease(Tween.EASE_OUT)
		else:
			time_label.scale = Vector2.ONE
