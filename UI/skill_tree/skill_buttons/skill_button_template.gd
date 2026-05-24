extends TextureButton
class_name SkillNode
 
@onready var panel = $Panel
@onready var line_2d = $Line2D

@export var skill_data: SkillResource

var level : int = 0:
	set(value):
		level = value

func _ready() -> void:
	if not skill_data:
		push_warning("SkillNode at %s is missing its SkillResource." % get_path())
		return

	level = SkillTreeConfig.upgrades[skill_data.upgrade_key] 
	
	if skill_data.texture:
		texture_normal = skill_data.texture
		
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
	
	level = min(level + 1, skill_data.max_level)
	SkillTreeConfig.upgrades[skill_data.upgrade_key] += 1
	skill_data.apply_upgrade()
	activate()
	line_2d.default_color = Color(1, 1, 0.24705882, 1)
	EventSystem.SFX_play_sfx.emit(SFXConfig.Keys.MenuBtnPressed)
	
	for skill in get_children():
		if skill is SkillNode and skill.skill_data:
			if SkillTreeConfig.upgrades[skill_data.upgrade_key] == skill_data.level_requirement_to_reveal:
				skill.visible = true
				skill.disabled = false
	
	if level >= skill_data.max_level:
		self_modulate = Color(1, 1, 0.24705882, 1)
		disabled = true

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
				skill.disabled = false
	
	if level >= skill_data.max_level:
		self_modulate = Color(1, 1, 0.24705882, 1)
		disabled = true

func _on_mouse_entered() -> void:
	EventSystem.BUL_create_bulletin.emit(BulletinConfig.Keys.SkillTreeToolTip, self)

func _on_mouse_exited() -> void:
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
