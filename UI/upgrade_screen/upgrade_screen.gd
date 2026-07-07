extends Bulletin
@onready var blur: ColorRect = %Blur
@onready var upgrades_controller: Node = %UpgradesController
@onready var close_menu_button: TextureButton = $MarginContainer/CloseMenuButton
@onready var upgrades_container: PanelContainer = %UpgradesContainer
@onready var player_money_label: Label = %PlayerMoneyLabel
@onready var player_stat_manager: PlayerStats = %PlayerStatManager

# buy buttons
@onready var chop_damage_buy_button: Button = %ChopDamageBuyButton
@onready var axe_speed_buy_button: Button = %AxeSpeedBuyButton
@onready var sprint_stamina_buy_button: Button = %SprintStaminaBuyButton
@onready var sprint_speed_buy_button: Button = %SprintSpeedBuyButton
@onready var backpack_size_buy_button: Button = %BackpackSizeBuyButton

# level labels
@onready var chop_damage_level_label: Label = %ChopDamageLevelLabel
@onready var axe_speed_level_label: Label = %AxeSpeedLevelLabel
@onready var sprint_stamina_level_label: Label = %SprintStaminaLevelLabel
@onready var sprint_speed_level_label: Label = %SprintSpeedLevelLabel
@onready var backpack_level_label: Label = %BackpackLevelLabel

# progress bars
@onready var chop_damage_progress_bar: ProgressBar = %ChopDamageProgressBar
@onready var axe_speed_progress_bar: ProgressBar = %AxeSpeedProgressBar
@onready var sprint_stamina_progress_bar: ProgressBar = %SprintStaminaProgressBar
@onready var sprint_speed_progress_bar: ProgressBar = %SprintSpeedProgressBar
@onready var backpack_progress_bar: ProgressBar = %BackpackProgressBar

# stat increase labels
@onready var chop_damage_stat_increase_label: Label = %ChopDamageStatIncreaseLabel
@onready var axe_speed_stat_increase_label: Label = %AxeSpeedStatIncreaseLabel
@onready var sprint_stamnia_stat_increase_label: Label = %SprintStamniaStatIncreaseLabel
@onready var sprint_speed_stat_increase_label: Label = %SprintSpeedStatIncreaseLabel
@onready var backpack_stat_increase_label: Label = %BackpackStatIncreaseLabel

const MAXED_BUTTON = preload("uid://doudgfaw4grl1")

var player_money = EventSystem.MON_get_player_money.call()

var entrance_tween: Tween

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventSystem.PLA_freeze_player.emit()
	EventSystem.HUD_hide_hud.emit()
	get_tree().paused = true
	
	player_money_label.text = "$" + str(player_money)
	
	setup_ui()
	setup_progress_bars()
	menu_transition_in()
	
	chop_damage_buy_button.pressed.connect(chop_damage_buy_button_pressed)
	axe_speed_buy_button.pressed.connect(axe_speed_buy_button_pressed)
	sprint_stamina_buy_button.pressed.connect(sprint_stamina_buy_button_pressed)
	sprint_speed_buy_button.pressed.connect(sprint_speed_buy_button_pressed)
	backpack_size_buy_button.pressed.connect(backpack_size_buy_button_pressed)
	
	EventSystem.UPG_upgrade_updated.connect(update_ui)

func setup_ui():
	UpgradeConfig.update_max_levels()
	
	chop_damage_level_label.text = "lvl %d/%d" % [UpgradeConfig.upgrades[UpgradeConfig.Keys.ChopDamage], UpgradeConfig.max_level[UpgradeConfig.Keys.ChopDamage]]
	axe_speed_level_label.text = "lvl %d/%d" % [UpgradeConfig.upgrades[UpgradeConfig.Keys.AxeSpeed], UpgradeConfig.max_level[UpgradeConfig.Keys.AxeSpeed]]
	sprint_stamina_level_label.text = "lvl %d/%d" % [UpgradeConfig.upgrades[UpgradeConfig.Keys.SprintStamina], UpgradeConfig.max_level[UpgradeConfig.Keys.SprintStamina]]
	sprint_speed_level_label.text = "lvl %d/%d" % [UpgradeConfig.upgrades[UpgradeConfig.Keys.SprintSpeed], UpgradeConfig.max_level[UpgradeConfig.Keys.SprintSpeed]]
	backpack_level_label.text = "lvl %d/%d" % [UpgradeConfig.upgrades[UpgradeConfig.Keys.BackPack], UpgradeConfig.max_level[UpgradeConfig.Keys.BackPack]]
	refresh_stat_labels()
	
	for i in range(5):
		var is_maxed: bool = (UpgradeConfig.upgrades[i] == UpgradeConfig.max_level[i])
		match i:
			UpgradeConfig.Keys.ChopDamage:
				if is_maxed:
					set_button_maxed(chop_damage_buy_button)
			UpgradeConfig.Keys.AxeSpeed:
				if is_maxed:
					set_button_maxed(axe_speed_buy_button)
			UpgradeConfig.Keys.SprintStamina:
				if is_maxed:
					set_button_maxed(sprint_stamina_buy_button)
			UpgradeConfig.Keys.SprintSpeed:
				if is_maxed:
					set_button_maxed(sprint_speed_buy_button)
			UpgradeConfig.Keys.BackPack: 
				if is_maxed:
					set_button_maxed(backpack_size_buy_button)

func setup_progress_bars():
	chop_damage_progress_bar.max_value = UpgradeConfig.max_level[UpgradeConfig.Keys.ChopDamage]
	axe_speed_progress_bar.max_value = UpgradeConfig.max_level[UpgradeConfig.Keys.AxeSpeed]
	sprint_stamina_progress_bar.max_value = UpgradeConfig.max_level[UpgradeConfig.Keys.SprintStamina]
	sprint_speed_progress_bar.max_value = UpgradeConfig.max_level[UpgradeConfig.Keys.SprintSpeed]
	backpack_progress_bar.max_value = UpgradeConfig.max_level[UpgradeConfig.Keys.BackPack]
	chop_damage_progress_bar.value = UpgradeConfig.upgrades[UpgradeConfig.Keys.ChopDamage]
	axe_speed_progress_bar.value = UpgradeConfig.upgrades[UpgradeConfig.Keys.AxeSpeed]
	sprint_stamina_progress_bar.value = UpgradeConfig.upgrades[UpgradeConfig.Keys.SprintStamina]
	sprint_speed_progress_bar.value = UpgradeConfig.upgrades[UpgradeConfig.Keys.SprintSpeed]
	backpack_progress_bar.value = UpgradeConfig.upgrades[UpgradeConfig.Keys.BackPack]

func update_ui(upgrade_key: UpgradeConfig.Keys, new_level: int) -> void:
	var is_maxed: bool = (new_level == UpgradeConfig.max_level[upgrade_key])
	var level_text: String = "lvl %d/%d" % [new_level, UpgradeConfig.max_level[upgrade_key]]
	
	match upgrade_key:
		UpgradeConfig.Keys.ChopDamage:
			chop_damage_level_label.text = level_text
			animate_progress_bar(chop_damage_progress_bar, new_level)
			if is_maxed:
				set_button_maxed(chop_damage_buy_button)
				
		UpgradeConfig.Keys.AxeSpeed:
			axe_speed_level_label.text = level_text
			animate_progress_bar(axe_speed_progress_bar, new_level)
			if is_maxed:
				set_button_maxed(axe_speed_buy_button)
				
		UpgradeConfig.Keys.SprintStamina:
			sprint_stamina_level_label.text = level_text
			animate_progress_bar(sprint_stamina_progress_bar, new_level)
			if is_maxed:
				set_button_maxed(sprint_stamina_buy_button)
				
		UpgradeConfig.Keys.SprintSpeed:
			sprint_speed_level_label.text = level_text
			animate_progress_bar(sprint_speed_progress_bar, new_level)
			if is_maxed:
				set_button_maxed(sprint_speed_buy_button)
				
		UpgradeConfig.Keys.BackPack: 
			backpack_level_label.text = level_text
			animate_progress_bar(backpack_progress_bar, new_level)
			if is_maxed:
				set_button_maxed(backpack_size_buy_button)
	
	refresh_stat_labels()

func set_button_maxed(button: Button) -> void:
	button.disabled = true
	button.text = "MAXED"
	var maxed_style = button.get_theme_stylebox("normal").duplicate() as StyleBoxFlat
	
	if maxed_style:
		maxed_style.bg_color = Color(0.831, 0.514, 0.004, 1.0)
		
		button.add_theme_stylebox_override("normal", maxed_style)
		button.add_theme_stylebox_override("hover", maxed_style)
		button.add_theme_stylebox_override("pressed", maxed_style)
		button.add_theme_stylebox_override("disabled", maxed_style) 

func menu_transition_in():
	entrance_tween = create_tween()
	entrance_tween.set_trans(Tween.TRANS_BACK)
	entrance_tween.set_ease(Tween.EASE_OUT)
	entrance_tween.tween_property(upgrades_container, "position:y", 114, 1.0).from(-1500)

func menu_transition_out():
	if entrance_tween and entrance_tween.is_valid():
		entrance_tween.kill()
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BACK)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(upgrades_container, "position:y", -1500, 0.5)
	tween.parallel().tween_property(blur, "modulate:a", 0.0, 0.5).from(1.0)
	tween.parallel().tween_property(close_menu_button, "modulate:a", 0.0, 0.5).from(1.0)
	tween.tween_callback(func(): 
		EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.UpgradeScreen)
		EventSystem.HUD_show_hud.emit()
	)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("close_menu"):
		close_menu()
		get_viewport().set_input_as_handled()

func _on_close_menu_button_pressed() -> void:
	close_menu()

func close_menu() -> void:
	EventSystem.PLA_unfreeze_player.emit()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	#SaveManager.save_skill_tree_upgrades()
	get_tree().paused = false
	menu_transition_out()

func chop_damage_buy_button_pressed() -> void:
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.UPG_upgrade_requested.emit(UpgradeConfig.Keys.ChopDamage)

func axe_speed_buy_button_pressed() -> void:
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.UPG_upgrade_requested.emit(UpgradeConfig.Keys.AxeSpeed)

func sprint_stamina_buy_button_pressed() -> void:
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.UPG_upgrade_requested.emit(UpgradeConfig.Keys.SprintStamina)

func sprint_speed_buy_button_pressed() -> void:
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.UPG_upgrade_requested.emit(UpgradeConfig.Keys.SprintSpeed)

func backpack_size_buy_button_pressed() -> void:
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.NormalButtonPressed)
	EventSystem.UPG_upgrade_requested.emit(UpgradeConfig.Keys.BackPack)

func animate_progress_bar(bar: Range, new_level: int) -> void:
	var target_value: float = min(new_level, bar.max_value)
	
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	
	tween.tween_property(bar, "value", target_value, 0.20)

func update_stat_increase_label(label: Label, current_val: float, next_val: float, stat_name: String = "", unit: String = "", prefix: String = "") -> void:
	var is_float: bool = (not is_equal_approx(current_val, round(current_val))) or (not is_equal_approx(next_val, round(next_val)))
	
	var current_str: String = "%.1f" % current_val if is_float else "%d" % int(current_val)
	var next_str: String = "%.1f" % next_val if is_float else "%d" % int(next_val)
	
	var final_text: String = "%s%s%s -> %s%s%s" % [prefix, current_str, unit, prefix, next_str, unit]
	if stat_name != "":
		final_text += " " + stat_name
		
	label.text = final_text


func refresh_stat_labels() -> void:
	var chop_lvl = UpgradeConfig.upgrades[UpgradeConfig.Keys.ChopDamage]
	var chop_max = UpgradeConfig.max_level[UpgradeConfig.Keys.ChopDamage]
	var current_dmg = player_stat_manager.get_axe_damage_at_level(chop_lvl)
	
	if chop_lvl >= chop_max:
		chop_damage_stat_increase_label.text = "%d Damage (MAX)" % int(current_dmg)
	else:
		var next_dmg = player_stat_manager.get_axe_damage_at_level(chop_lvl + 1)
		update_stat_increase_label(chop_damage_stat_increase_label, current_dmg, next_dmg, "DMG")
	
	var axe_lvl = UpgradeConfig.upgrades[UpgradeConfig.Keys.AxeSpeed]
	var axe_max = UpgradeConfig.max_level[UpgradeConfig.Keys.AxeSpeed]
	var current_axe_spd = player_stat_manager.get_axe_speed_at_level(axe_lvl)
	
	if axe_lvl >= axe_max:
		axe_speed_stat_increase_label.text = "%.1f (MAX)" % current_axe_spd
	else:
		var next_axe_spd = player_stat_manager.get_axe_speed_at_level(axe_lvl + 1)
		update_stat_increase_label(axe_speed_stat_increase_label, current_axe_spd, next_axe_spd, "", "", "x")
	
	var stam_lvl = UpgradeConfig.upgrades[UpgradeConfig.Keys.SprintStamina]
	var stam_max = UpgradeConfig.max_level[UpgradeConfig.Keys.SprintStamina]
	
	if stam_lvl >= stam_max:
		sprint_stamnia_stat_increase_label.text = "%d Seconds (MAX)" % (stam_lvl + 1)
	else:
		update_stat_increase_label(sprint_stamnia_stat_increase_label, stam_lvl + 1, stam_lvl + 2, "Seconds")
	
	var sprint_lvl = UpgradeConfig.upgrades[UpgradeConfig.Keys.SprintSpeed]
	var sprint_max = UpgradeConfig.max_level[UpgradeConfig.Keys.SprintSpeed]
	var current_spd = player_stat_manager.get_sprint_multi_at_level(sprint_lvl)
	
	if sprint_lvl >= sprint_max:
		sprint_speed_stat_increase_label.text = "x%.1f (MAX)" % current_spd
	else:
		var next_spd = player_stat_manager.get_sprint_multi_at_level(sprint_lvl + 1)
		update_stat_increase_label(sprint_speed_stat_increase_label, current_spd, next_spd, "", "", "x")
	
	var bag_lvl = UpgradeConfig.upgrades[UpgradeConfig.Keys.BackPack]
	var bag_max = UpgradeConfig.max_level[UpgradeConfig.Keys.BackPack]
	var current_slots = player_stat_manager.get_inventory_size_at_level(bag_lvl)
	
	if bag_lvl >= bag_max:
		backpack_stat_increase_label.text = "%d slots (MAX)" % int(current_slots)
	else:
		var next_slots = player_stat_manager.get_inventory_size_at_level(bag_lvl + 1)
		update_stat_increase_label(backpack_stat_increase_label, current_slots, next_slots, "slots")
