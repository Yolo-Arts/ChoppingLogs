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
	EventSystem.HUD_update_time.connect(func(new_time: String): time_label.text = new_time)
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
