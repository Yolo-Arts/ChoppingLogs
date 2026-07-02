extends Bulletin
@onready var blur: ColorRect = %Blur
@onready var upgrades_controller: Node = %UpgradesController
@onready var close_menu_button: TextureButton = $MarginContainer/CloseMenuButton
@onready var upgrades_container: PanelContainer = %UpgradesContainer
@onready var player_money_label: Label = %PlayerMoneyLabel
@onready var chop_damage_buy_button: Button = %ChopDamageBuyButton
@onready var axe_speed_buy_button: Button = %AxeSpeedBuyButton
@onready var sprint_stamina_buy_button: Button = %SprintStaminaBuyButton
@onready var sprint_speed_buy_button: Button = %SprintSpeedBuyButton
@onready var backpack_size_buy_button: Button = %BackpackSizeBuyButton
@onready var chop_damage_level_label: Label = %ChopDamageLevelLabel
@onready var axe_speed_level_label: Label = %AxeSpeedLevelLabel
@onready var sprint_stamina_level_label: Label = %SprintStaminaLevelLabel
@onready var sprint_speed_level_label: Label = %SprintSpeedLevelLabel
@onready var backpack_level_label: Label = %BackpackLevelLabel

var player_money = EventSystem.MON_get_player_money.call()

var entrance_tween: Tween

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	EventSystem.PLA_freeze_player.emit()
	EventSystem.HUD_hide_hud.emit()
	get_tree().paused = true
	
	player_money_label.text = "$" + str(player_money)
	
	menu_transition_in()
	
	chop_damage_buy_button.pressed.connect(chop_damage_buy_button_pressed)
	axe_speed_buy_button.pressed.connect(axe_speed_buy_button_pressed)
	sprint_stamina_buy_button.pressed.connect(sprint_stamina_buy_button_pressed)
	sprint_speed_buy_button.pressed.connect(sprint_speed_buy_button_pressed)
	backpack_size_buy_button.pressed.connect(backpack_size_buy_button_pressed)
	
	EventSystem.UPG_upgrade_updated.connect(update_ui)

func update_ui(upgrade_key: UpgradeConfig.Keys, new_level: int):
	match upgrade_key:
		0:
			chop_damage_level_label.text = "lvl" + str(new_level) + "/" + str(UpgradeConfig.max_level[upgrade_key])
		1:
			axe_speed_level_label.text = "lvl" + str(new_level) + "/" + str(UpgradeConfig.max_level[upgrade_key])
		2:
			sprint_stamina_level_label.text = "lvl" + str(new_level) + "/" + str(UpgradeConfig.max_level[upgrade_key])
		3:
			sprint_speed_level_label.text = "lvl" + str(new_level) + "/" + str(UpgradeConfig.max_level[upgrade_key])
		4: 
			backpack_level_label.text = "lvl" + str(new_level) + "/" + str(UpgradeConfig.max_level[upgrade_key])


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
	#SaveManager.save_upgrades()
	get_tree().paused = false
	menu_transition_out()

func chop_damage_buy_button_pressed():
	EventSystem.UPG_upgrade_requested.emit(UpgradeConfig.Keys.ChopDamage)

func axe_speed_buy_button_pressed():
	EventSystem.UPG_upgrade_requested.emit(UpgradeConfig.Keys.AxeSpeed)

func sprint_stamina_buy_button_pressed():
	EventSystem.UPG_upgrade_requested.emit(UpgradeConfig.Keys.SprintStamina)

func sprint_speed_buy_button_pressed():
	EventSystem.UPG_upgrade_requested.emit(UpgradeConfig.Keys.SprintSpeed)

func backpack_size_buy_button_pressed():
	EventSystem.UPG_upgrade_requested.emit(UpgradeConfig.Keys.BackPack)
