extends Bulletin

@onready var results_container: PanelContainer = %ResultsContainer
@onready var trees_cut_count_lbl: Label = %TreesCutCountLbl
@onready var todays_revenue_number_lbl: Label = %TodaysRevenueNumberLbl
@onready var quota_number_lbl: Label = %QuotaNumberLbl
@onready var balance_number_lbl: Label = %BalanceNumberLbl
@onready var prestige_points_number_lbl: Label = %PrestigePointsNumberLbl
@onready var trees_cut_lbl: Label = %TreesCutLbl
@onready var todays_revenue_lbl: Label = %TodaysRevenueLbl
@onready var quota_lbl: Label = %QuotaLbl
@onready var balance_lbl: Label = %BalanceLbl
@onready var prestige_points_lbl: Label = %PrestigePointsLbl
@onready var label_categories: VBoxContainer = %LabelCategories
@onready var label_numbers: VBoxContainer = %LabelNumbers
@onready var shaker: Shaker = $Shaker
@onready var continue_button: Button = %ContinueButton
@onready var back_to_menu: TextureButton = %BackToMenu

var quota = 500

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventSystem.HUD_hide_hud.emit()
	get_tree().paused = true
	
	hide_labels()
	hide_buttons()
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(results_container, "position:y", 81, 1.0).from(-1500)
	
	#await tween.finished
	#animate_stats()
	tween.tween_callback(animate_stats)

func initialize(_extra_arg) -> void:
	pass

func hide_labels():
	for child in label_categories.get_children():
		child.self_modulate.a = 0.0
	for child in label_numbers.get_children():
		child.self_modulate.a = 0.0

func hide_buttons():
	for child in $MarginContainer/ResultsContainer/VBoxContainer/ButtonsContainer.get_children():
		child.modulate.a = 0.0

func animate_stats():
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for child in label_categories.get_children():
		tween.tween_property(child, "position:x", 0.0, 0.25).from(-get_viewport().size.x)
		tween.parallel().tween_property(child, "self_modulate:a", 1.0, 0.25).from(0.0)
	
	tween.tween_interval(0.25)
	
	# Hard coded tweens
	#FIXLATER the values are purely visual
	tween.tween_method(set_label_number.bind(trees_cut_count_lbl), 0, 143, 0.5)
	tween.parallel().tween_property(trees_cut_count_lbl, "self_modulate:a", 1.0, 0.05).from(0.0)
	tween.parallel().tween_callback(shaker.start.bind(0.25))
	tween.tween_interval(0.25)
	
	tween.tween_method(set_label_number.bind(quota_number_lbl), 0, -2228, 0.5)
	tween.parallel().tween_property(quota_number_lbl, "self_modulate:a", 1.0, 0.05).from(0.0)
	tween.parallel().tween_callback(shaker.start.bind(0.25))
	tween.tween_interval(0.25)
	
	tween.tween_method(set_label_number.bind(todays_revenue_number_lbl), 0, 8900, 0.5)
	tween.parallel().tween_property(todays_revenue_number_lbl, "self_modulate:a", 1.0, 0.05).from(0.0)
	tween.parallel().tween_callback(shaker.start.bind(0.25))
	tween.tween_interval(0.25)
	
	tween.tween_method(set_label_number.bind(balance_number_lbl), 0, 8900 - 2228, 0.5)
	tween.parallel().tween_property(balance_number_lbl, "self_modulate:a", 1.0, 0.05).from(0.0)
	tween.parallel().tween_callback(shaker.start.bind(0.25))
	tween.tween_interval(0.25)
	
	tween.tween_method(set_label_number.bind(prestige_points_number_lbl), 0, 178, 0.5)
	tween.parallel().tween_property(prestige_points_number_lbl, "self_modulate:a", 1.0, 0.05).from(0.0)
	tween.parallel().tween_callback(shaker.start.bind(0.25))
	tween.tween_interval(0.25)
	
	tween.tween_callback(transition_buttons)
	

func set_label_number(number: int, label: Label) -> void:
	label.set_text(str(number))

func transition_buttons():
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(continue_button, "position:y", 0, 0.5).from(1200)
	tween.parallel().tween_property(continue_button, "modulate:a", 1, 0.1).from(0.0)
	tween.parallel().tween_property(back_to_menu, "position:y", 0, 0.5).from(1200)
	tween.parallel().tween_property(back_to_menu, "modulate:a", 1, 0.1).from(0.0)

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	EventSystem.QUO_increase_quota_amount.emit()
	EventSystem.STA_change_stage.emit(StageConfig.Keys.Prototype)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.ResultsScreen)

func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.ResultsScreen)
	EventSystem.STA_change_stage.emit(StageConfig.Keys.MainMenu)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.MenuBtnPressed)
