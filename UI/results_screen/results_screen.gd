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
@onready var quota_percentage: Label = %QuotaPercentage
@onready var quota_progress_bar: ProgressBar = %QuotaProgressBar
@onready var overflow_container: VBoxContainer = %OverflowContainer
@onready var quota_overflow_percentage: Label = %QuotaOverflowPercentage
@onready var quota_overflow_progress_bar: ProgressBar = %QuotaOverflowProgressBar
@onready var progress_bar_h_split_container: HSplitContainer = %ProgressBarHSplitContainer
@onready var stats_for_day_x_label: Label = %StatsForDayXLabel

var trees_cut = EventSystem.TRE_get_tree_cut_amount.call()
var quota = EventSystem.QUO_get_quota_amount.call()
var todays_revenue = EventSystem.MON_get_player_money.call()
var progress_bar_width = 818
var prestige_price = 50


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventSystem.HUD_hide_hud.emit()
	get_tree().paused = true
	
	hide_labels()
	hide_buttons()
	quota_overflow_progress_bar.visible = false
	overflow_container.visible = false
	
	stats_for_day_x_label.text = "Stats For Day " + str(EventSystem.QUO_get_day_number.call())
	
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
	fill_quota_progress_bar()
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	
	for child in label_categories.get_children():
		tween.tween_property(child, "position:x", 0.0, 0.25).from(-get_viewport().size.x)
		tween.parallel().tween_property(child, "self_modulate:a", 1.0, 0.25).from(0.0)
	
	tween.tween_interval(0.25)
	
	
	tween.tween_method(set_label_number.bind(trees_cut_count_lbl), 0, trees_cut, 0.5)
	tween.parallel().tween_property(trees_cut_count_lbl, "self_modulate:a", 1.0, 0.05).from(0.0)
	tween.parallel().tween_callback(shaker.start.bind(0.25))
	tween.tween_interval(0.25)
	
	tween.tween_method(set_label_number.bind(quota_number_lbl), 0, -quota, 0.5)
	tween.parallel().tween_property(quota_number_lbl, "self_modulate:a", 1.0, 0.05).from(0.0)
	tween.parallel().tween_callback(shaker.start.bind(0.25))
	tween.tween_interval(0.25)
	
	tween.tween_method(set_label_number.bind(todays_revenue_number_lbl), 0, todays_revenue, 0.5)
	tween.parallel().tween_property(todays_revenue_number_lbl, "self_modulate:a", 1.0, 0.05).from(0.0)
	tween.parallel().tween_callback(shaker.start.bind(0.25))
	tween.tween_interval(0.25)
	
	
	tween.tween_method(set_label_number.bind(balance_number_lbl), 0, todays_revenue - quota, 0.5)
	tween.parallel().tween_property(balance_number_lbl, "self_modulate:a", 1.0, 0.05).from(0.0)
	tween.parallel().tween_callback(shaker.start.bind(0.25))
	tween.tween_interval(0.25)
	
	tween.tween_method(set_label_number.bind(prestige_points_number_lbl), 0, int(todays_revenue / prestige_price), 0.5)
	tween.parallel().tween_property(prestige_points_number_lbl, "self_modulate:a", 1.0, 0.05).from(0.0)
	tween.parallel().tween_callback(shaker.start.bind(0.25))
	tween.tween_interval(0.25)
	
	tween.tween_callback(transition_buttons)

func set_label_number(number: int, label: Label) -> void:
	match label:
		trees_cut_count_lbl:
			label.set_text(str(number) + " trees cut")
		quota_number_lbl, todays_revenue_number_lbl, balance_number_lbl:
			if number < 0:
				label.set_text("-$" + str(abs(number)))
			else:
				label.set_text("$" + str(number))
		prestige_points_number_lbl:
			label.set_text(str(number) + "p")
		_:
			label.set_text(str(number))

func fill_quota_progress_bar():
	var quota_percentage_tween: Tween = create_tween()
	quota_percentage_tween.tween_method(func(v): quota_percentage.text = "%.f%%" % v, 0.0, min((todays_revenue / float(quota)) * 100.0, 100), 2.5)
	
	quota_progress_bar.max_value = quota
	quota_overflow_progress_bar.visible = false
	quota_overflow_progress_bar.custom_minimum_size.x = 0
	quota_progress_bar.custom_minimum_size.x = 0
	overflow_container.visible = false
	
	const SPLIT_MIN = -360.0
	const SPLIT_MAX = 360.0
	progress_bar_h_split_container.split_offset = SPLIT_MAX
	progress_bar_h_split_container.custom_minimum_size.x = progress_bar_width
	progress_bar_h_split_container.clip_contents = true
	
	var overflow_amount = todays_revenue - quota
	
	var bar_tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	bar_tween.tween_property(quota_progress_bar, "value", todays_revenue, 2.5).from(0)
	
	if overflow_amount > 0:
		var total_amount = quota + overflow_amount
		var overflow_ratio = float(overflow_amount) / total_amount
		var target_split_offset = lerp(SPLIT_MAX, SPLIT_MIN, overflow_ratio)
		
		var overflow_percentage = (float(overflow_amount) / quota) * 100.0
		
		quota_overflow_progress_bar.max_value = overflow_amount
		quota_overflow_progress_bar.value = quota_overflow_progress_bar.max_value
		
		bar_tween.tween_callback(func():
			overflow_container.visible = true
			quota_overflow_progress_bar.visible = true
		)
		
		bar_tween.tween_property(progress_bar_h_split_container, "split_offset", target_split_offset, 4.5)
		bar_tween.parallel().tween_method(func(v): quota_overflow_percentage.text = "%.f%%" % v, 0.0, overflow_percentage, 4.5)

func transition_buttons():
	var tween: Tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(continue_button, "position:y", 0, 0.5).from(1200)
	tween.parallel().tween_property(continue_button, "modulate:a", 1, 0.1).from(0.0)
	tween.parallel().tween_property(back_to_menu, "position:y", 0, 0.5).from(1200)
	tween.parallel().tween_property(back_to_menu, "modulate:a", 1, 0.1).from(0.0)

func _on_continue_button_pressed() -> void:
	get_tree().paused = false
	
	var met_quota = EventSystem.QUO_check_quota.call()
	if met_quota:
		EventSystem.QUO_increase_quota_amount.emit()
	else:
		EventSystem.QUO_reset_quota.emit()
	
	EventSystem.STA_change_stage.emit(StageConfig.Keys.Prototype)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.ResultsScreen)


func _on_back_to_menu_pressed() -> void:
	get_tree().paused = false
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.ResultsScreen)
	EventSystem.STA_change_stage.emit(StageConfig.Keys.MainMenu)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.MenuBtnPressed)
