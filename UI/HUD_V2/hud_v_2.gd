extends Control

@onready var money_label: Label = %MoneyLabel
@onready var time_label: Label = %TimeLabel
@onready var quota_amount: Label = %QuotaAmount
@onready var encroaching_dark: ColorRect = %EncroachingDark
@onready var encroaching_dark_player: AnimationPlayer = $EncroachingDarkPlayer
@export var sprint_container: HBoxContainer
@export var stamina_bar: ProgressBar
@onready var inventory_size: Label = %InventorySize
@onready var prestige_points: Label = %PrestigePoints


func _ready() -> void:
	EventSystem.HUD_reset_hud_elements.connect(reset_hud_elements)
	EventSystem.MON_money_updated.connect(update_text)
	EventSystem.MON_cannot_decrease_money.connect(func():
		update_text(EventSystem.MON_get_player_money.call(), Color.RED)
	)
	
	EventSystem.HUD_update_time.connect(_on_time_updated)
	EventSystem.QUO_update_quota_text.connect(update_quota_text)
	EventSystem.DAR_encroaching_dark_start.connect(encroaching_dark_start)
	EventSystem.DAR_reset_encroaching_dark.connect(reset_encroaching_dark)
	EventSystem.HUD_update_stamina.connect(_update_stamina)
	EventSystem.HUD_update_inventory_label.connect(update_inventory_label)
	EventSystem.HUD_update_prestige_points.connect(update_prestige_label)

func reset_hud_elements():
	#money_label.text = "$" + str(0.0)
	money_label.text = "$%.2f" % 0.00

func reset_encroaching_dark():
	encroaching_dark_player.play("RESET")

var last_money_value = 0
func update_text(money: float, color: Color):
	money_label.text = "$%.2f" % money

	var tween = create_tween()
	tween.tween_method(set_label_number.bind(money_label), last_money_value, float(money), 0.5)
	last_money_value = money
	apply_text_effect(money_label, color)

func update_quota_text() -> void:
	quota_amount.text = "/ $" + str(EventSystem.QUO_get_quota_amount.call())

func _update_stamina(stamina: float, max_stam_changed: bool = false) -> void:
	if max_stam_changed:
		stamina_bar.max_value = stamina # move to different signal if we want more robust behaviour for max stamina increases
		return
	stamina_bar.value = stamina
	sprint_container.visible = stamina_bar.value != stamina_bar.max_value

func update_inventory_label(current_size: int, max_size: int) -> void:
	inventory_size.text = str(current_size) + " / " + str(max_size)

func update_prestige_label(prestige_points_amount: float):
	#var tween = create_tween()
	#tween.tween_method(set_label_number.bind(prestige_points), 0, float(prestige_points_amount), 0.5)
	prestige_points.text = "%.1f" % prestige_points_amount

func apply_text_effect(label: Label, color: Color):
	var tween = create_tween().set_parallel(true)
	
	var color_chain = create_tween()
	color_chain.tween_property(label, "theme_override_colors/font_color", color, 0.1)
	
	color_chain.tween_property(label, "theme_override_colors/font_color", Color.WHITE, 0.3).set_delay(0.1)
	
	tween.tween_property(label, "scale", Vector2(1.2, 1.2), 0.1).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(label, "scale", Vector2(1.0, 1.0), 0.2).set_delay(0.1)

func set_label_number(number: float, label: Label) -> void:
	match label:
		money_label:
			#label.set_text("$" + str(number))
			label.set_text("$%.2f" % (number))
		_:
			label.set_text(str(number))

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

func encroaching_dark_start() -> void:
	print("encroaching dark started")
	encroaching_dark.visible = true
	encroaching_dark_player.play("start_encroaching_dark")
	#await encroaching_dark_player.animation_finished
	#encroaching_dark.visible = false
	#EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.ResultsScreen)

func fire_results_screen():
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.ResultsScreen)
	
