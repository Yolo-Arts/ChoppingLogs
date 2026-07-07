extends Control
class_name SkillNode
 
@onready var button: TextureButton = $Button
@onready var panel = %Panel
@onready var line_2d = $Line2D

@export var skill_data: SkillResource

var level : int = 0:
	set(value):
		level = value

var _can_show_tooltip: bool = true
var _hover_tween: Tween

func _ready() -> void:
	if not skill_data:
		push_warning("SkillNode at %s is missing its SkillResource." % get_path())
		return

	button.pressed.connect(_on_pressed)
	button.mouse_entered.connect(_on_mouse_entered)
	button.mouse_exited.connect(_on_mouse_exited)
	button.gui_input.connect(func(event: InputEvent) -> void: _gui_input(event))

	level = SkillTreeConfig.upgrades[skill_data.upgrade_key] 
	
	if skill_data.texture:
		button.texture_normal = skill_data.texture
		
	if level > 0:
		activate()
		
	if get_parent() is SkillNode:
		line_2d.clear_points()
		var my_center = global_position + (size / 2)
		var parent_center = get_parent().global_position + (get_parent().size / 2)
		
		line_2d.add_point(line_2d.to_local(my_center))
		line_2d.add_point(line_2d.to_local(parent_center))

func _on_pressed() -> void:
	if not skill_data: return
	pressed_animation()
	var calculated_cost = int(skill_data.upgrade_cost * pow(skill_data.price_increase_mult_per_level, level))
	if EventSystem.MON_get_player_money.call() < calculated_cost:
		print("Not enough money")
		EventSystem.MON_cannot_decrease_money.emit()
		return
	
	EventSystem.MON_decrease_money.emit(calculated_cost)
	level = min(level + 1, skill_data.max_level)
	SkillTreeConfig.upgrades[skill_data.upgrade_key] += 1
	
	#SaveManager.save_skill_tree_upgrades()
	
	skill_data.apply_upgrade()
	activate()
	line_2d.default_color = Color(1, 1, 0.24705882, 1)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.MenuBtnPressed)
	
	for skill in get_children():
		if skill is SkillNode and skill.skill_data:
			if SkillTreeConfig.upgrades[skill_data.upgrade_key] == skill_data.level_requirement_to_reveal:
				skill.visible = true
				skill.button.disabled = false
				skill.animate_reveal()
	
	if level >= skill_data.max_level:
		button.self_modulate = Color(1, 1, 0.24705882, 1)
		button.disabled = true

func activate() -> void:
	if not skill_data: return
	panel.show_behind_parent = true
	panel.visible = false
	line_2d.default_color = Color(1, 1, 0.24705882, 1)
	
	for skill in get_children():
		if skill is SkillNode and skill.skill_data:
			if SkillTreeConfig.upgrades[skill_data.upgrade_key] >= skill_data.level_requirement_to_reveal:
				skill.show_behind_parent = true
				skill.visible = true
				skill.button.disabled = false
	
	if level >= skill_data.max_level:
		button.self_modulate = Color(1, 1, 0.24705882, 1)
		button.disabled = true

func _on_mouse_entered() -> void:
	if not _can_show_tooltip:
		return
	hover_animation()
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.SkillTreeToolTip, self)

func _on_mouse_exited() -> void:
	reset_hover_animation()
	EventSystem.BUL_destroy_bulletin.emit(BulletinConfig.Keys.SkillTreeToolTip)

func _gui_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT)) or \
	   (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT):
		var zoom_node = get_parent()
		while zoom_node != null and zoom_node.name != "ZoomContent":
			zoom_node = zoom_node.get_parent()
			
		if zoom_node:
			zoom_node._gui_input(event)

func label_is_valid() -> bool:
	return skill_data and has_node("%Label")

# all tween and juicy animation functions for the skill node below:

func animate_pop_in(delay: float) -> void:
	_can_show_tooltip = false
	button.pivot_offset = button.size / 2
	button.scale = Vector2.ZERO
	button.rotation_degrees = 0.0
	
	if line_2d:
		line_2d.modulate.a = 0.0
	
	var pop_tween = create_tween()
	pop_tween.set_parallel(false) 
	pop_tween.tween_interval(delay)
	
	pop_tween.tween_property(button, "scale", Vector2(0.8, 1.35), 0.15)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		
	pop_tween.tween_property(button, "scale", Vector2(1.15, 0.85), 0.1)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
	pop_tween.tween_property(button, "scale", Vector2.ONE, 0.08)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	
	if line_2d:
		pop_tween.tween_property(line_2d, "modulate:a", 1.0, 0.2)\
			.set_trans(Tween.TRANS_SINE)\
			.set_ease(Tween.EASE_IN_OUT)
	
	pop_tween.tween_callback(func(): 
		_can_show_tooltip = true
		if button.is_hovered():
			EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.SkillTreeToolTip, self)
	)

func hover_animation() -> void:
	button.pivot_offset = button.size / 2
	
	if _hover_tween and _hover_tween.is_valid():
		_hover_tween.kill()
	
	# used to randomise the initial direction of the rotation when hovered between left or right.
	var random = randi_range(1, 2)
	var multiplier = 1
	match (random):
		1:
			multiplier = 1
		2:
			multiplier = -1
	
	_hover_tween = create_tween()
	
	_hover_tween.tween_property(button, "scale", Vector2(1.22, 1.22), 0.12)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_hover_tween.parallel().tween_property(button, "rotation_degrees", multiplier * 8.0, 0.12)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		
	_hover_tween.tween_property(button, "scale", Vector2(1.05, 1.05), 0.1)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	_hover_tween.parallel().tween_property(button, "rotation_degrees", multiplier * -6.0, 0.1)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
	_hover_tween.tween_property(button, "scale", Vector2(1.12, 1.12), 0.08)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
	_hover_tween.parallel().tween_property(button, "rotation_degrees", multiplier * 0.0, 0.08)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func reset_hover_animation() -> void:
	if _hover_tween and _hover_tween.is_valid():
		_hover_tween.kill()
		
	_hover_tween = create_tween()
	_hover_tween.set_parallel(true)
	
	_hover_tween.tween_property(button, "scale", Vector2.ONE, 0.15)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_hover_tween.tween_property(button, "rotation_degrees", 0.0, 0.15)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func pressed_animation() -> void:
	if _hover_tween and _hover_tween.is_valid():
		_hover_tween.kill()
	var tween = create_tween()
	
	tween.tween_property(button, "scale", Vector2(1.22, 1.22), 0.12).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(button, "scale", Vector2(1.12, 1.12), 0.08).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)

func animate_reveal() -> void:
	_can_show_tooltip = false
	button.pivot_offset = button.size / 2
	
	button.scale = Vector2.ZERO
	button.modulate.a = 0.0
	button.rotation_degrees = randf_range(-15.0, 15.0) 
	
	if line_2d:
		line_2d.modulate.a = 0.0

	var reveal_tween = create_tween()
	reveal_tween.set_parallel(true)
	
	reveal_tween.tween_property(button, "scale", Vector2(1.3, 1.3), 0.22)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	reveal_tween.tween_property(button, "modulate:a", 1.0, 0.15)
	reveal_tween.tween_property(button, "rotation_degrees", 0.0, 0.25)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		
	if line_2d:
		reveal_tween.tween_property(line_2d, "modulate:a", 1.0, 0.3)\
			.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
		
	reveal_tween.chain().tween_property(button, "scale", Vector2.ONE, 0.12)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN_OUT)
		
	reveal_tween.tween_callback(func():
		_can_show_tooltip = true
		if button.is_hovered():
			EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.SkillTreeToolTip, self)
	)
